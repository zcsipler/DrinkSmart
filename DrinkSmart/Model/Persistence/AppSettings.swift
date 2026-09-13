import Foundation
import Observation
import BACKit

/// User settings: who you are and how you want the numbers shown.
///
/// Deliberately separate from the session history. Settings describe you
/// *now*; a session records who you were *then*. Conflating the two is what
/// would make old curves rewrite themselves.
///
/// Still in UserDefaults rather than SwiftData. A single settings row is
/// awkward under CloudKit — two devices can each create one before the first
/// sync, and then you have to pick a winner. Re-entering four values on a new
/// device is cheaper than getting that merge wrong. Worth revisiting once the
/// history sync has proven itself.
@Observable
final class AppSettings {

    var profile: BodyProfile {
        didSet { persist() }
    }

    /// The personal limit in g/L. Not a legal limit.
    var limit: Double {
        didSet { persist() }
    }

    var unit: BACUnit {
        didSet { persist() }
    }

    /// Proxy for the elimination rate. Setting it rewrites the profile's beta.
    var frequency: DrinkingFrequency {
        didSet {
            guard frequency != oldValue else { return }
            frequency.apply(to: &profile)   // profile's didSet persists
        }
    }

    /// When this app started keeping records.
    ///
    /// Needed to tell two very different empty days apart. Before this date we
    /// have no idea whether you drank; after it, an empty day means you did
    /// not. Claiming the first is the second would be inventing history.
    var trackingStartedAt: Date {
        didSet { persist() }
    }

    init(
        profile: BodyProfile = .init(sex: .male, age: 35, heightCm: 180, weightKg: 80),
        limit: Double = 0.8,
        unit: BACUnit = .perMille
    ) {
        self.profile = profile
        self.limit = limit
        self.unit = unit
        self.frequency = .closest(toBeta: profile.beta)
        self.trackingStartedAt = .now
        load()
    }

    /// Moves the start of tracking earlier, never later.
    ///
    /// Called by the legacy import: drinks that predate this install are
    /// evidence that we were already keeping records then.
    func backdateTracking(to date: Date) {
        guard date < trackingStartedAt else { return }
        trackingStartedAt = date
    }

    // MARK: Storage

    private struct Snapshot: Codable {
        var profile: BodyProfile
        var limit: Double
        var unit: BACUnit
        var frequency: DrinkingFrequency
        /// Optional so a snapshot written before this existed still decodes.
        var trackingStartedAt: Date?
    }

    private static let storageKey = "drinksmart.settings.v1"

    private func persist() {
        let snapshot = Snapshot(
            profile: profile, limit: limit, unit: unit,
            frequency: frequency, trackingStartedAt: trackingStartedAt
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: Self.storageKey),
            let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data)
        else {
            // No settings of our own yet — the legacy session blob carried them.
            loadFromLegacyIfPresent()
            return
        }

        profile = snapshot.profile
        limit = snapshot.limit
        unit = snapshot.unit
        frequency = snapshot.frequency
        // An older snapshot has no start date; the install is the best guess.
        trackingStartedAt = snapshot.trackingStartedAt ?? .now
    }

    /// The pre-SwiftData store kept settings inside the session snapshot.
    /// Lift them out so a user upgrading does not lose their profile.
    private func loadFromLegacyIfPresent() {
        guard let legacy = LegacySessionSnapshot.stored() else { return }
        profile = legacy.profile
        limit = legacy.limit
        unit = legacy.unit
        frequency = legacy.frequency
        if let earliest = legacy.drinks.map(\.consumedAt).min() {
            trackingStartedAt = earliest
        }
        persist()
    }
}
