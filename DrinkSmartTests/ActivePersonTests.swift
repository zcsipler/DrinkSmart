import Foundation
import SwiftData
import Testing
import BACKit
@testable import DrinkSmart

/// Who the app is recording when it is opened again.
///
/// The rule: a switch lasts for the drinking day it was made on (5.6). The
/// failure it exists to prevent is not mis-tapping — it is switching to
/// somebody else at 11pm and recording your own drinks under her name the
/// following week.
@MainActor
@Suite("Active person")
struct ActivePersonTests {

    private func makeSettings() -> AppSettings {
        let defaults = UserDefaults(suiteName: "drinksmart.tests.\(UUID().uuidString)")!
        return AppSettings(defaults: defaults)
    }

    @Test("Nothing chosen means the owner")
    func defaultsToOwner() {
        #expect(makeSettings().activePersonIDIfCurrent() == nil)
    }

    @Test("A switch holds for the rest of the evening, past midnight")
    func survivesMidnight() {
        let settings = makeSettings()
        let guest = UUID()

        // Chosen at 23:00, read at 02:30 — still the same drinking day.
        let elevenPM = date(day: 10, hour: 23)
        settings.setActivePerson(guest, at: elevenPM)

        #expect(settings.activePersonIDIfCurrent(at: date(day: 11, hour: 2, minute: 30)) == guest)
    }

    @Test("It lapses once the drinking day turns over")
    func lapsesNextDay() {
        let settings = makeSettings()
        settings.setActivePerson(UUID(), at: date(day: 10, hour: 23))

        // 05:00 is the boundary: by half past, this is a new day and the app
        // is recording for you again.
        #expect(settings.activePersonIDIfCurrent(at: date(day: 11, hour: 5, minute: 30)) == nil)
    }

    @Test("A store started the next day comes back as the owner")
    func storeFallsBackToOwner() throws {
        // Two stores over one database: the second one is what a launch
        // tomorrow looks like.
        let context = try makeContext()
        let settings = makeSettings()

        let store = SessionStore(context: context, settings: settings)
        let guest = store.addPerson(
            name: "Guest",
            profile: .test,
            frequency: .occasional,
            limit: 0.8
        )
        #expect(store.person.id == guest.id)

        settings.setActivePerson(guest.id, at: .now.addingTimeInterval(-48 * 3600))
        let reopened = SessionStore(context: context, settings: settings)

        #expect(reopened.person.id == reopened.owner.id)
        // The lapsed choice is cleared, not left to be misread later.
        #expect(settings.activePersonID == nil)
    }

    @Test("Switching back to the owner clears the stored choice")
    func switchingBackClears() throws {
        let store = try makeStore()
        let owner = store.owner
        store.addPerson(name: "Guest", profile: .test, frequency: .occasional, limit: 0.8)

        #expect(store.settings.activePersonID != nil)

        store.activate(owner)

        #expect(store.settings.activePersonID == nil)
        #expect(store.person.id == owner.id)
    }

    // MARK: Removing a person

    @Test("Removing a guest takes their occasions, drinks and monthly totals, and lands on the owner")
    func removingAGuestCascades() throws {
        let context = try makeContext()
        let store = SessionStore(context: context, settings: makeSettings())
        let guest = store.addPerson(name: "Guest", profile: .test, frequency: .occasional, limit: 0.8)
        store.add(.beer(at: .now.addingTimeInterval(-3600)))
        store.add(.beer(at: .now.addingTimeInterval(-1800)))
        context.insert(MonthlyTotal(personID: guest.id, year: 2025, month: 6, gramsEthanol: 400))
        try context.save()

        let plan = try #require(store.removalPlan(for: guest))
        #expect(plan.sessions == 1)
        #expect(plan.drinks == 2)
        #expect(plan.monthlyTotals == 1)
        #expect(store.person.id == guest.id)

        store.removePerson(guest)

        #expect(store.person.id == store.owner.id)
        #expect(store.settings.activePersonID == nil)
        #expect(store.people.count == 1)
        #expect(try context.fetch(FetchDescriptor<DrinkingSession>()).isEmpty)
        #expect(try context.fetch(FetchDescriptor<DrinkRecord>()).isEmpty)
        #expect(try context.fetch(FetchDescriptor<MonthlyTotal>()).isEmpty)
        #expect(store.drinks.isEmpty)
    }

    @Test("Removing a guest who is not active leaves the active person alone")
    func removingAnotherGuestKeepsTheActiveOne() throws {
        let store = try makeStore()
        let first = store.addPerson(name: "First", profile: .test, frequency: .occasional, limit: 0.8)
        let second = store.addPerson(name: "Second", profile: .test, frequency: .occasional, limit: 0.8)
        #expect(store.person.id == second.id)

        store.removePerson(first)

        #expect(store.person.id == second.id)
        #expect(store.people.map(\.id) == [store.owner.id, second.id])
    }

    @Test("The owner cannot be removed")
    func ownerIsNeverRemoved() throws {
        let store = try makeStore()
        #expect(store.removalPlan(for: store.owner) == nil)

        store.removePerson(store.owner)

        #expect(store.people.count == 1)
        #expect(store.people.first?.isOwner == true)
    }

    // MARK: Helpers

    /// A fixed date in a month that has no daylight-saving edge in it.
    private func date(day: Int, hour: Int, minute: Int = 0) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 11
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
}
