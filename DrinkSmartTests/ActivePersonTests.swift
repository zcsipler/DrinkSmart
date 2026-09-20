import Foundation
import Testing
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
