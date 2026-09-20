import Foundation
import SwiftData
import BACKit

/// Puts an archive back into the store, without ever removing anything.
///
/// ## Merge, not replace
///
/// Rows are matched by `id`: unknown ones are inserted, known ones are left
/// exactly as they are. On a new phone the store is empty, so merging and
/// replacing are the same thing — which is the case this feature exists for.
/// They differ when somebody restores an old archive onto an app they have kept
/// using, and there the merge is the one that cannot destroy an evening. For an
/// operation with no undo, the safe reading of an ambiguous request wins.
///
/// It also makes the import **idempotent**: running the same file twice changes
/// nothing the second time.
///
/// ## An existing occasion is skipped whole, drinks included
///
/// Reconciling drink by drink inside an occasion that exists on both sides
/// would need a rule for a drink present in both with different times — and
/// there is no honest rule, because nothing records which edit came later.
/// Guessing would silently overwrite a correction the user made by hand.
/// Skipping is predictable and explainable in one sentence, which is what an
/// irreversible operation needs.
enum ArchiveImport {

    /// What an import would do, worked out before anything is written.
    ///
    /// Computed separately so the confirmation can state it. "Import" on its
    /// own asks the user to accept consequences nobody has shown them.
    struct Plan {
        let archive: DataArchive
        let newPeopleIDs: Set<UUID>
        let newSessionIDs: Set<UUID>

        var peopleToAdd: Int { newPeopleIDs.count }
        var sessionsToAdd: Int { newSessionIDs.count }

        var drinksToAdd: Int {
            archive.sessions
                .filter { newSessionIDs.contains($0.id) }
                .reduce(0) { $0 + $1.drinks.count }
        }

        /// Occasions in the file that are already here. Worth showing: it is
        /// the difference between "this file is redundant" and "this file is
        /// the wrong one".
        var sessionsAlreadyPresent: Int {
            archive.sessions.count - sessionsToAdd
        }

        var changesNothing: Bool {
            newPeopleIDs.isEmpty && newSessionIDs.isEmpty
        }
    }

    /// What an import did, plus the owner that survived it.
    ///
    /// The owner is returned because the deduplication below can delete the one
    /// the caller was holding — see `resolveOwnerConflict`.
    struct Outcome {
        let owner: Person
        let peopleAdded: Int
        let sessionsAdded: Int
        let drinksAdded: Int
    }

    // MARK: Planning

    static func plan(_ archive: DataArchive, in context: ModelContext) -> Plan {
        let existingPeople = Set(
            ((try? context.fetch(FetchDescriptor<Person>())) ?? []).map(\.id)
        )
        let existingSessions = Set(
            ((try? context.fetch(FetchDescriptor<DrinkingSession>())) ?? []).map(\.id)
        )

        return Plan(
            archive: archive,
            newPeopleIDs: Set(archive.people.map(\.id)).subtracting(existingPeople),
            newSessionIDs: Set(archive.sessions.map(\.id)).subtracting(existingSessions)
        )
    }

    // MARK: Applying

    @discardableResult
    static func apply(_ plan: Plan, in context: ModelContext) -> Outcome {
        let inserted = insertPeople(plan, in: context)
        let (sessions, drinks) = insertSessions(plan, people: inserted, in: context)

        try? context.save()

        return Outcome(
            owner: resolveOwnerConflict(in: context),
            peopleAdded: inserted.count,
            sessionsAdded: sessions,
            drinksAdded: drinks
        )
    }

    /// - Returns: the people this import created, by id.
    private static func insertPeople(_ plan: Plan, in context: ModelContext) -> [UUID: Person] {
        var created: [UUID: Person] = [:]

        for archived in plan.archive.people where plan.newPeopleIDs.contains(archived.id) {
            let profile = BodyProfile(
                sex: Sex(rawValue: archived.sexRaw) ?? .male,
                age: archived.age,
                heightCm: archived.heightCm,
                weightKg: archived.weightKg,
                beta: archived.beta,
                betaUncertainty: archived.betaUncertainty
            )

            // `Person.init` writes `frequencyRaw` directly rather than going
            // through the `frequency` setter, so the archived beta survives —
            // the setter would recompute it from the frequency band and quietly
            // discard a rate the user had tuned by hand (5.3).
            let person = Person(
                id: archived.id,
                name: archived.name,
                isOwner: archived.isOwner,
                createdAt: archived.createdAt,
                accent: PersonAccent(rawValue: archived.accentRaw) ?? .teal,
                profile: profile,
                frequency: DrinkingFrequency(rawValue: archived.frequencyRaw)
                    ?? .closest(toBeta: archived.beta),
                limit: archived.limit,
                trackingStartedAt: archived.trackingStartedAt
            )
            person.favourite = archived.favourite

            context.insert(person)
            created[archived.id] = person
        }

        return created
    }

    private static func insertSessions(
        _ plan: Plan,
        people created: [UUID: Person],
        in context: ModelContext
    ) -> (sessions: Int, drinks: Int) {
        guard !plan.newSessionIDs.isEmpty else { return (0, 0) }

        // Everyone who could own an imported occasion: the ones just created
        // plus the ones already here.
        var owners = created
        for person in (try? context.fetch(FetchDescriptor<Person>())) ?? [] {
            owners[person.id] = person
        }
        let fallback = owners.values.first(where: \.isOwner)

        var sessionCount = 0
        var drinkCount = 0

        for archived in plan.archive.sessions where plan.newSessionIDs.contains(archived.id) {
            let profile = BodyProfile(
                sex: Sex(rawValue: archived.sexRaw) ?? .male,
                age: archived.age,
                heightCm: archived.heightCm,
                weightKg: archived.weightKg,
                beta: archived.beta,
                betaUncertainty: archived.betaUncertainty
            )

            // An occasion whose person is in neither place would be invisible:
            // every query filters on a person. The owner is the only landing
            // spot that is guaranteed to exist.
            let session = DrinkingSession(
                id: archived.id,
                startedAt: archived.startedAt,
                endedAt: archived.endedAt,
                person: owners[archived.personID] ?? fallback,
                profile: profile,
                limit: archived.limit
            )
            context.insert(session)
            sessionCount += 1

            for drink in archived.drinks {
                let record = DrinkRecord(
                    Drink(
                        id: drink.id,
                        consumedAt: drink.consumedAt,
                        volumeMl: drink.volumeMl,
                        abvPercent: drink.abvPercent,
                        stomach: StomachState(rawValue: drink.stomachRaw) ?? .light,
                        drinkingMinutes: drink.drinkingMinutes,
                        name: drink.templateID
                    )
                )
                record.session = session
                context.insert(record)
                drinkCount += 1
            }
        }

        return (sessionCount, drinkCount)
    }

    /// Two owners after an import, and only one may survive.
    ///
    /// The archive carries an owner, and so does this device — `PersonMigration`
    /// creates one on first launch, before any import can run. That is the same
    /// collision two devices produce before their first CloudKit sync, so it is
    /// settled by the same code rather than a second rule written to agree with
    /// the first: the earlier `createdAt` wins and inherits the other's
    /// occasions.
    ///
    /// On a new phone the local owner was made moments ago and the archived one
    /// months earlier, so the archived profile wins — which is the point of
    /// restoring a backup. Restoring an old archive onto an app in use goes the
    /// other way, and the profile the user has been editing stays.
    private static func resolveOwnerConflict(in context: ModelContext) -> Person {
        PersonMigration.run(in: context)
    }
}
