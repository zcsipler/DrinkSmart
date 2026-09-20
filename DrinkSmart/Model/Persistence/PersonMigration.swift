import Foundation
import SwiftData
import BACKit

/// Gives every session an owner, and the app its first `Person`.
///
/// Runs on every launch, before anything reads a session, and **regardless of
/// the multi-person feature flag**. A schema behind a flag would need this
/// migration the moment the flag went on and would hide existing rows the
/// moment it went off; the flag hides UI (see `FeatureFlags`).
///
/// ## Why there is no "already ran" flag
///
/// The guard is the data itself: an owner is created only when there is none,
/// and the sweep only touches sessions that have no person. A UserDefaults
/// marker would be actively wrong here — with CloudKit, a session created on a
/// device that predates this version can arrive *after* the marker was set,
/// and it would never get an owner. Two fetches on launch is the cheaper
/// mistake.
enum PersonMigration {

    /// - Returns: the owner. There is always exactly one.
    @discardableResult
    static func run(in context: ModelContext) -> Person {
        let owner = resolveOwner(in: context)
        adoptOrphanedSessions(by: owner, in: context)

        if context.hasChanges {
            try? context.save()
        }
        return owner
    }

    // MARK: The owner

    private static func resolveOwner(in context: ModelContext) -> Person {
        let existing = (try? context.fetch(
            FetchDescriptor<Person>(sortBy: [SortDescriptor(\.createdAt)])
        )) ?? []

        let owners = existing.filter(\.isOwner)

        if let first = owners.first {
            // Two devices can each create an owner before the first CloudKit
            // sync — the same race that keeps `AppSettings` out of SwiftData.
            // The earlier one wins and inherits the other's sessions.
            for duplicate in owners.dropFirst() {
                merge(duplicate, into: first, in: context)
            }
            return first
        }

        // A person exists but none is the owner: possible only if a future
        // version lets the owner be deleted, or after a botched sync. The
        // oldest person is the best guess, and leaving *no* owner is not an
        // option — the active person falls back to it.
        if let oldest = existing.first {
            oldest.isOwner = true
            return oldest
        }

        let owner = makeOwner(from: LegacyProfileSettings.stored(), or: LegacySessionSnapshot.stored())
        context.insert(owner)
        return owner
    }

    /// The owner is built from whatever the pre-`Person` app knew: first the
    /// settings it wrote, then the even older session blob, then defaults.
    /// Losing a carefully set weight to a silent default would be a bad first
    /// impression of a migration.
    ///
    /// Takes its sources as arguments rather than reading `UserDefaults`, so
    /// the fallback chain is testable without a global side effect.
    static func makeOwner(
        from legacy: LegacyProfileSettings?,
        or blob: LegacySessionSnapshot?
    ) -> Person {
        if let legacy {
            return Person(
                isOwner: true,
                profile: legacy.profile,
                frequency: legacy.frequency,
                limit: legacy.limit,
                trackingStartedAt: legacy.trackingStartedAt ?? .now
            )
        }

        if let blob {
            return Person(
                isOwner: true,
                profile: blob.profile,
                frequency: blob.frequency,
                limit: blob.limit,
                trackingStartedAt: blob.drinks.map(\.consumedAt).min() ?? .now
            )
        }

        let profile = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
        return Person(
            isOwner: true,
            profile: profile,
            frequency: .closest(toBeta: profile.beta),
            limit: 0.8
        )
    }

    private static func merge(_ duplicate: Person, into winner: Person, in context: ModelContext) {
        for session in duplicate.sessions ?? [] {
            session.assign(to: winner)
        }
        duplicate.sessions = []
        winner.backdateTracking(to: duplicate.trackingStartedAt)
        context.delete(duplicate)
    }

    // MARK: Sessions without a person

    /// Everything recorded before this version, plus anything the legacy
    /// import just created, plus late arrivals from another device.
    private static func adoptOrphanedSessions(by owner: Person, in context: ModelContext) {
        let unassigned = Person.unassignedID
        let descriptor = FetchDescriptor<DrinkingSession>(
            predicate: #Predicate { $0.personID == unassigned }
        )

        guard let orphans = try? context.fetch(descriptor) else { return }
        for session in orphans {
            session.assign(to: owner)
        }
    }
}
