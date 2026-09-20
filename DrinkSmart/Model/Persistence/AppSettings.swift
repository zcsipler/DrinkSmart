import Foundation
import Observation
import BACKit

/// What belongs to this device rather than to a person.
///
/// The body, the elimination rate, the personal limit and the start of records
/// moved onto `Person` — they describe someone, and there can now be more than
/// one of them. What is left describes the app: the unit the figures are shown
/// in, and who is currently being recorded.
///
/// Still UserDefaults rather than SwiftData, and now for a second reason on top
/// of the original one. The original: a single settings row is awkward under
/// CloudKit, because two devices can each create one before the first sync and
/// then somebody has to lose. The new one: the active person is a piece of UI
/// state. Syncing it would mean that switching to a guest on the phone in a bar
/// also switches the iPad at home, which nobody asked for.
@Observable
final class AppSettings {

    var unit: BACUnit {
        didSet { persist() }
    }

    // MARK: Who is being recorded
    //
    // Two values, not one: the id, and when it was chosen. Switching to
    // somebody else is an evening's context, and the most likely mistake with
    // it is not mis-tapping — it is switching at 11pm and forgetting by
    // morning. So the choice expires with the drinking day (5.6).
    //
    // Expiry by timestamp rather than by "was the app relaunched": coming back
    // from the background must not reset anything, and an app the system kills
    // at midnight must not silently start recording the wrong person's drinks.

    private(set) var activePersonID: UUID?
    private(set) var activePersonChosenAt: Date?

    func setActivePerson(_ id: UUID, at date: Date = .now) {
        activePersonID = id
        activePersonChosenAt = date
        persist()
    }

    func clearActivePerson() {
        guard activePersonID != nil || activePersonChosenAt != nil else { return }
        activePersonID = nil
        activePersonChosenAt = nil
        persist()
    }

    /// The active person, but only while the choice is still today's.
    /// Nil means the owner.
    func activePersonIDIfCurrent(at date: Date = .now) -> UUID? {
        guard let activePersonID, let activePersonChosenAt else { return nil }
        guard DrinkingDay.containing(activePersonChosenAt).isCurrent(at: date) else { return nil }
        return activePersonID
    }

    /// `defaults` is injectable for the same reason `LegacyProfileSettings`
    /// takes one: a test must be able to run against a throwaway suite, and
    /// one test leaking its active person into the next is exactly the kind of
    /// flake that gets a whole suite disabled.
    private let defaults: UserDefaults

    init(unit: BACUnit = .perMille, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.unit = unit
        load()
    }

    // MARK: Storage
    //
    // A new key. The old one (`LegacyProfileSettings.storageKey`) still holds
    // the profile that `PersonMigration` reads, and writing over it with a
    // slimmer shape would destroy the only copy that predates the database.

    private struct Snapshot: Codable {
        var unit: BACUnit
        var activePersonID: UUID?
        var activePersonChosenAt: Date?
    }

    private static let storageKey = "drinksmart.device.v1"

    private func persist() {
        let snapshot = Snapshot(
            unit: unit,
            activePersonID: activePersonID,
            activePersonChosenAt: activePersonChosenAt
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }

    private func load() {
        if let data = defaults.data(forKey: Self.storageKey),
           let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) {
            unit = snapshot.unit
            activePersonID = snapshot.activePersonID
            activePersonChosenAt = snapshot.activePersonChosenAt
            return
        }

        // First launch after the split: the unit is the one setting here that
        // the user had already chosen, so it is carried over rather than reset.
        if let legacy = LegacyProfileSettings.stored(in: defaults) {
            unit = legacy.unit
        } else if let blob = LegacySessionSnapshot.stored(in: defaults) {
            unit = blob.unit
        }
    }
}
