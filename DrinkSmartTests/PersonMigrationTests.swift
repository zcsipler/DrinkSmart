import Foundation
import SwiftData
import Testing
import BACKit
@testable import DrinkSmart

/// The migration that gives every session an owner.
///
/// None of the failures here crash or log anything. A session that keeps the
/// unassigned id is not deleted — it is simply invisible, because every query
/// in the app filters by person. That is what "losing data" means in this
/// codebase, and it is why these cases are worth a test each.
@MainActor
@Suite("Person migration")
struct PersonMigrationTests {

    // MARK: Creating the owner

    @Test("An empty database gets exactly one owner")
    func createsOwner() throws {
        let context = try makeContext()

        let owner = PersonMigration.run(in: context)
        let people = try context.fetch(FetchDescriptor<Person>())

        #expect(people.count == 1)
        #expect(owner.isOwner)
        #expect(people.first?.id == owner.id)
    }

    @Test("Running twice does not create a second owner")
    func isIdempotent() throws {
        let context = try makeContext()

        let first = PersonMigration.run(in: context)
        let second = PersonMigration.run(in: context)

        #expect(first.id == second.id)
        #expect(try context.fetch(FetchDescriptor<Person>()).count == 1)
    }

    @Test("The owner inherits the profile the app had before")
    func takesLegacyProfile() {
        let legacy = LegacyProfileSettings(
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            limit: 0.4,
            unit: .percent,
            frequency: .rarely,
            trackingStartedAt: Date(timeIntervalSince1970: 1_700_000_000)
        )

        let owner = PersonMigration.makeOwner(from: legacy, or: nil)

        // Silently defaulting here would leave every curve wrong, with nothing
        // on screen to say so.
        #expect(owner.profile.sex == .female)
        #expect(owner.profile.weightKg == 58)
        #expect(owner.profile.heightCm == 166)
        #expect(owner.profile.age == 29)
        #expect(owner.limit == 0.4)
        #expect(owner.frequency == .rarely)
        #expect(owner.trackingStartedAt == Date(timeIntervalSince1970: 1_700_000_000))
    }

    @Test("With no settings at all it falls back to the older session blob")
    func fallsBackToLegacyBlob() {
        let firstDrink = Date(timeIntervalSince1970: 1_600_000_000)
        let blob = LegacySessionSnapshot(
            profile: BodyProfile(sex: .male, age: 44, heightCm: 191, weightKg: 96),
            limit: 0.6,
            unit: .perMille,
            frequency: .daily,
            drinks: [Drink(consumedAt: firstDrink, volumeMl: 500, abvPercent: 5)]
        )

        let owner = PersonMigration.makeOwner(from: nil, or: blob)

        #expect(owner.profile.weightKg == 96)
        #expect(owner.frequency == .daily)
        // Records demonstrably start no later than the oldest drink we hold.
        #expect(owner.trackingStartedAt == firstDrink)
    }

    // MARK: Adopting sessions

    @Test("A session with no person is adopted by the owner")
    func adoptsOrphan() throws {
        let context = try makeContext()
        let orphan = DrinkingSession(startedAt: .now, profile: .test, limit: 0.8)
        context.insert(orphan)
        #expect(orphan.personID == Person.unassignedID)

        let owner = PersonMigration.run(in: context)

        #expect(orphan.personID == owner.id)
        #expect(orphan.person?.id == owner.id)
    }

    @Test("An already assigned session is left alone")
    func doesNotStealAssignedSessions() throws {
        let context = try makeContext()
        let owner = PersonMigration.run(in: context)
        let guest = makeGuest(in: context)

        let hers = DrinkingSession(startedAt: .now, person: guest, profile: .test, limit: 0.8)
        context.insert(hers)

        PersonMigration.run(in: context)

        #expect(hers.personID == guest.id)
        #expect(hers.personID != owner.id)
    }

    // MARK: Two owners

    @Test("Two owners are merged, and the sessions follow")
    func mergesDuplicateOwners() throws {
        let context = try makeContext()

        let earlier = Person(
            isOwner: true,
            createdAt: Date(timeIntervalSince1970: 1_000),
            profile: .test,
            frequency: .occasional,
            limit: 0.8,
            trackingStartedAt: Date(timeIntervalSince1970: 5_000)
        )
        let later = Person(
            isOwner: true,
            createdAt: Date(timeIntervalSince1970: 2_000),
            profile: .test,
            frequency: .occasional,
            limit: 0.8,
            trackingStartedAt: Date(timeIntervalSince1970: 3_000)
        )
        context.insert(earlier)
        context.insert(later)

        let strandedSession = DrinkingSession(startedAt: .now, person: later, profile: .test, limit: 0.8)
        context.insert(strandedSession)

        let owner = PersonMigration.run(in: context)
        let people = try context.fetch(FetchDescriptor<Person>())

        // Without the merge the user sees two identical "You" entries and
        // half their history behind the one they cannot reach.
        #expect(people.count == 1)
        #expect(owner.id == earlier.id)
        #expect(strandedSession.personID == earlier.id)
        // The surviving owner keeps the earliest start of records.
        #expect(owner.trackingStartedAt == Date(timeIntervalSince1970: 3_000))
    }

    @Test("A database with people but no owner promotes the oldest")
    func promotesOldestWhenNoOwner() throws {
        let context = try makeContext()
        let older = Person(
            createdAt: Date(timeIntervalSince1970: 1_000),
            profile: .test, frequency: .occasional, limit: 0.8
        )
        let newer = Person(
            createdAt: Date(timeIntervalSince1970: 2_000),
            profile: .test, frequency: .occasional, limit: 0.8
        )
        context.insert(older)
        context.insert(newer)

        let owner = PersonMigration.run(in: context)

        #expect(owner.id == older.id)
        #expect(try context.fetch(FetchDescriptor<Person>()).count == 2)
    }
}
