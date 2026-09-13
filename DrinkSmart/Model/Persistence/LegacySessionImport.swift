import Foundation
import SwiftData
import BACKit

/// The shape the pre-SwiftData store wrote into UserDefaults.
///
/// Kept as a standalone type so the import does not depend on the current
/// `SessionStore`, which has since changed. Decoding old data against a moving
/// target is how migrations quietly lose rows.
struct LegacySessionSnapshot: Codable {
    var profile: BodyProfile
    var limit: Double
    var unit: BACUnit
    var frequency: DrinkingFrequency
    var drinks: [Drink]

    static let storageKey = "drinksmart.session.v2"

    static func stored() -> LegacySessionSnapshot? {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return nil }
        return try? JSONDecoder().decode(LegacySessionSnapshot.self, from: data)
    }
}

/// One-time import of the old single-session blob into the session history.
///
/// Two deliberate choices:
///
/// 1. **The source key is never deleted.** It costs a few kilobytes and it is
///    the only copy of data that predates the database. If the import turns
///    out to be wrong, the original is still there to redo it from.
/// 2. **The 24-hour cutoff is not applied.** The old store dropped anything
///    older on every launch, which was reasonable when the app only covered
///    tonight. Here we take everything that survived.
enum LegacySessionImport {

    private static let completionKey = "drinksmart.legacyImport.completed.v1"

    static var hasRun: Bool {
        UserDefaults.standard.bool(forKey: completionKey)
    }

    /// Imports the legacy blob if there is one and it has not been imported yet.
    ///
    /// - Returns: the session it created, or nil when there was nothing to do.
    @discardableResult
    static func run(in context: ModelContext) -> DrinkingSession? {
        guard !hasRun else { return nil }
        defer { UserDefaults.standard.set(true, forKey: completionKey) }

        guard let legacy = LegacySessionSnapshot.stored(), !legacy.drinks.isEmpty else {
            return nil
        }

        let ordered = legacy.drinks.sorted { $0.consumedAt < $1.consumedAt }
        guard let first = ordered.first else { return nil }

        let session = DrinkingSession(
            startedAt: first.consumedAt,
            profile: legacy.profile,
            limit: legacy.limit
        )
        context.insert(session)

        for drink in ordered {
            let record = DrinkRecord(drink)
            record.session = session
            context.insert(record)
        }

        // Whether this session is still running is decided by the same rule
        // that governs every other session, not by a special case here.
        let band = BACEngine().simulateBand(profile: legacy.profile, drinks: ordered)
        if !SessionPolicy.isStillOpen(band: band, lastDrinkAt: ordered.last?.consumedAt, at: .now) {
            session.endedAt = SessionPolicy.closingDate(
                lastDrinkAt: ordered.last?.consumedAt,
                soberAt: band.soberRange()?.upperBound
            )
        }

        try? context.save()
        return session
    }

    /// Lets the import run again. Debug affordance only — the legacy key is
    /// still there, so this is recoverable rather than destructive.
    static func reset() {
        UserDefaults.standard.removeObject(forKey: completionKey)
    }
}
