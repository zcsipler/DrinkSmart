import Foundation
import SwiftData
import Testing
import BACKit
@testable import DrinkSmart

/// Which person a drink ends up on, and which session.
///
/// Every case here used to be impossible: with one person there was nowhere
/// else for a drink to go. They are all silent failures — no crash, no log,
/// just a row on the wrong evening or a number computed from the wrong body.
@MainActor
@Suite("Session routing")
struct SessionRoutingTests {

    @Test("A drink goes to the active person")
    func drinkFollowsActivePerson() throws {
        let store = try makeStore()
        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )

        // addPerson switches over, which is the behaviour the sheet relies on.
        #expect(store.person.id == guest.id)

        store.add(.beer(at: .now.addingTimeInterval(-600)))

        #expect(store.session?.personID == guest.id)
        #expect(store.drinks.count == 1)
    }

    @Test("Switching back shows the owner's session, not the guest's")
    func switchingSwapsTheOpenSession() throws {
        let store = try makeStore()
        let owner = store.owner

        store.add(.beer(at: .now.addingTimeInterval(-3600)))
        let ownersSession = try #require(store.session)

        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )
        store.add(.beer(at: .now.addingTimeInterval(-1800)))
        let guestsSession = try #require(store.session)

        #expect(guestsSession.id != ownersSession.id)
        #expect(store.drinks.count == 1)

        store.activate(owner)

        #expect(store.session?.id == ownersSession.id)
        #expect(store.drinks.count == 1)
        #expect(guest.sessions?.count == 1)
    }

    @Test("A backdated drink does not land in the other person's evening")
    func backdatedDrinkStaysWithItsPerson() throws {
        let store = try makeStore()
        let owner = store.owner
        let threeWeeksAgo = Date.now.addingTimeInterval(-21 * 24 * 3600)

        // The guest drank that evening.
        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )
        store.add(.beer(at: threeWeeksAgo))
        let hers = try #require(guest.sessions?.first)

        // The owner fills in his own drink from the same evening, weeks later.
        store.activate(owner)
        store.add(.beer(at: threeWeeksAgo.addingTimeInterval(1800)))

        let ownersSessions = owner.sessions ?? []
        #expect(ownersSessions.count == 1)
        #expect(ownersSessions.first?.id != hers.id)
        // Her evening stays one drink long. Without the person filter this is
        // where the owner's beer would have silently appeared.
        #expect(hers.drinks?.count == 1)
    }

    @Test("A backdated session freezes its own person's body, not the nearest one")
    func backdatedSessionUsesOwnProfile() throws {
        let store = try makeStore()
        let owner = store.owner
        let sixMonthsAgo = Date.now.addingTimeInterval(-180 * 24 * 3600)

        // A guest session sits closest in time to the drink about to be added.
        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )
        store.add(.beer(at: sixMonthsAgo))

        store.activate(owner)
        store.add(.beer(at: sixMonthsAgo.addingTimeInterval(3 * 24 * 3600)))

        let backdated = try #require(owner.sessions?.first)
        // 58 kg here would mean the curve describes an evening that never
        // happened — and nothing on screen would look wrong.
        #expect(backdated.weightKg == owner.profile.weightKg)
        #expect(backdated.sexRaw == Sex.male.rawValue)
        #expect(guest.sessions?.first?.weightKg == 58)
    }

    @Test("An inactive person's finished evening still gets closed")
    func closesSessionsOfEveryone() throws {
        let store = try makeStore()
        let owner = store.owner

        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )
        store.add(.beer(at: .now.addingTimeInterval(-3600)))
        #expect(guest.sessions?.first?.isOpen == true)

        store.activate(owner)

        // Two days later, from the owner's side of the app.
        store.now = .now.addingTimeInterval(48 * 3600)
        store.refreshFromStore()

        // A session that never closes never reaches History and never gets a
        // summary — her evening would simply not exist anywhere in the app.
        #expect(guest.sessions?.first?.isOpen == false)
        #expect(guest.sessions?.first?.summary != nil)
    }

    @Test("Deleting the last drink removes the session, and only that one")
    func deletingLastDrinkKeepsOtherPeople() throws {
        let store = try makeStore()
        let owner = store.owner

        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )
        store.add(.beer(at: .now.addingTimeInterval(-1800)))

        store.activate(owner)
        let mine = Drink.beer(at: .now.addingTimeInterval(-1200))
        store.add(mine)
        store.remove(mine)

        #expect(store.session == nil)
        #expect(owner.sessions?.isEmpty == true)
        #expect(guest.sessions?.count == 1)
    }

    @Test("The profile screen edits the selected person")
    func profileEditsFollowTheActivePerson() throws {
        let store = try makeStore()
        let owner = store.owner
        let guest = store.addPerson(
            name: "Guest",
            profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: 58),
            frequency: .occasional,
            limit: 0.8
        )

        store.profile.weightKg = 60
        store.limit = 0.5

        #expect(guest.weightKg == 60)
        #expect(guest.limit == 0.5)
        #expect(owner.weightKg == 80)
        #expect(owner.limit == 0.8)
    }
}
