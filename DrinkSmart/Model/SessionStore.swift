import Foundation
import Observation
import BACKit

/// The app's single source of state.
///
/// The band is recomputed only when an input actually changes (a drink, the
/// profile). The clock tick just moves `now`, which refreshes the readout
/// without starting a new simulation.
@Observable
final class SessionStore {

    // MARK: State

    var profile: BodyProfile {
        didSet { rebuild(); persist() }
    }

    /// The user's own limit in g/L. Not a legal limit — a personal reference.
    var limit: Double {
        didSet { persist() }
    }

    var unit: BACUnit {
        didSet { persist() }
    }

    /// Proxy for beta. Changing this rewrites the profile's beta values.
    var frequency: DrinkingFrequency {
        didSet {
            guard frequency != oldValue else { return }
            frequency.apply(to: &profile)   // the profile's didSet rebuilds and persists
        }
    }

    private(set) var drinks: [Drink] = []
    private(set) var band: BACBand = .empty

    /// The current time. Refreshed every half minute.
    var now: Date = .now

    private let engine = BACEngine()

    // MARK: Lifecycle

    init(
        profile: BodyProfile = .init(sex: .male, age: 35, heightCm: 180, weightKg: 80),
        limit: Double = 0.8,
        unit: BACUnit = .perMille
    ) {
        self.profile = profile
        self.limit = limit
        self.unit = unit
        self.frequency = .closest(toBeta: profile.beta)
        load()
        rebuild()
    }

    // MARK: Derived values

    /// The range of possible current levels. This is what the main readout shows.
    var currentRange: ClosedRange<Double> {
        drinks.isEmpty ? 0...0 : band.range(at: now)
    }

    /// The centre value — needed where a single number is unavoidable, such as
    /// tinting and animation.
    var currentBAC: Double {
        drinks.isEmpty ? 0 : band.value(at: now)
    }

    var peakRange: ClosedRange<Double>? { band.peakRange }
    var peak: BACSample? { band.peak }

    /// The peak is only "expected" while it is still ahead of us.
    var upcomingPeak: BACSample? {
        guard let peak, peak.date > now.addingTimeInterval(60) else { return nil }
        return peak
    }

    var soberRange: ClosedRange<Date>? {
        drinks.isEmpty ? nil : band.soberRange()
    }

    var sessionStart: Date? {
        drinks.map(\.consumedAt).min()
    }

    var sessionDuration: TimeInterval {
        guard let start = sessionStart else { return 0 }
        return max(now.timeIntervalSince(start), 0)
    }

    var totalUnits: Double {
        drinks.reduce(0) { $0 + $1.standardUnits }
    }

    var limitOutcome: LimitOutcome {
        guard !drinks.isEmpty else { return .below }
        let range = currentRange
        if range.lowerBound >= limit { return .above }
        if range.upperBound >= limit { return .uncertain }
        return .below
    }

    /// Whether the curve is currently rising. The absorption limb is where a
    /// breathalyser would read low.
    var isRising: Bool {
        !drinks.isEmpty && currentRate > 0.01
    }

    var currentRate: Double {
        band.center.samples.last { $0.date <= now }?.rate ?? 0
    }

    /// The visible time window. At least six hours, but wide enough to contain
    /// the full clearance.
    var visibleRange: ClosedRange<Date> {
        let start = (sessionStart ?? now).addingTimeInterval(-15 * 60)
        let naturalEnd = soberRange?.upperBound ?? now.addingTimeInterval(4 * 3600)
        let end = max(naturalEnd.addingTimeInterval(20 * 60), start.addingTimeInterval(6 * 3600))
        return start...end
    }

    var yMaximum: Double {
        max((peakRange?.upperBound ?? 0) * 1.3, limit * 1.4, 0.5)
    }

    // MARK: Actions

    func add(_ drink: Drink) {
        drinks.append(drink)
        drinks.sort { $0.consumedAt < $1.consumedAt }
        rebuild()
        persist()
    }

    /// Replaces an already logged drink. Re-sorts, because an edit can move
    /// the drink to a different point in the session.
    func update(_ drink: Drink) {
        guard let index = drinks.firstIndex(where: { $0.id == drink.id }) else { return }
        drinks[index] = drink
        drinks.sort { $0.consumedAt < $1.consumedAt }
        rebuild()
        persist()
    }

    func remove(_ drink: Drink) {
        drinks.removeAll { $0.id == drink.id }
        rebuild()
        persist()
    }

    func clearSession() {
        drinks.removeAll()
        rebuild()
        persist()
    }

    /// What would happen if the user had this drink.
    ///
    /// When correcting an already logged drink, pass its id as `excluding`:
    /// the comparison is then "the session without it" against "the session
    /// with the corrected version", rather than counting the drink twice.
    func project(_ candidate: Drink, excluding excludedID: UUID? = nil) -> BandedProjection {
        let others = excludedID.map { id in drinks.filter { $0.id != id } } ?? drinks
        return engine.projectBand(profile: profile, consumed: others, candidate: candidate, limit: limit)
    }

    func tick() {
        now = .now
    }

    private func rebuild() {
        band = drinks.isEmpty ? .empty : engine.simulateBand(profile: profile, drinks: drinks)
    }

    // MARK: Persistence
    //
    // UserDefaults + Codable for now. The SwiftData layer arrives when we need
    // statistics across past sessions.

    private struct Snapshot: Codable {
        var profile: BodyProfile
        var limit: Double
        var unit: BACUnit
        var frequency: DrinkingFrequency
        var drinks: [Drink]
    }

    private static let storageKey = "drinksmart.session.v2"

    private func persist() {
        let snapshot = Snapshot(
            profile: profile, limit: limit, unit: unit, frequency: frequency, drinks: drinks
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: Self.storageKey),
            let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data)
        else { return }

        profile = snapshot.profile
        limit = snapshot.limit
        unit = snapshot.unit
        frequency = snapshot.frequency
        // Keep only the last 24 hours — anything older has already cleared.
        let cutoff = Date.now.addingTimeInterval(-24 * 3600)
        drinks = snapshot.drinks.filter { $0.consumedAt > cutoff }.sorted { $0.consumedAt < $1.consumedAt }
    }
}

// MARK: - Preview data

extension SessionStore {
    static var preview: SessionStore {
        let store = SessionStore()
        // `name` holds the template identifier, not the displayed name.
        store.drinks = [
            Drink(consumedAt: .now.addingTimeInterval(-9000), volumeMl: 500, abvPercent: 5, stomach: .full, name: "beer"),
            Drink(consumedAt: .now.addingTimeInterval(-5400), volumeMl: 500, abvPercent: 5, stomach: .light, name: "beer"),
            Drink(consumedAt: .now.addingTimeInterval(-2700), volumeMl: 150, abvPercent: 12, stomach: .light, name: "wine"),
            Drink(consumedAt: .now.addingTimeInterval(-900), volumeMl: 40, abvPercent: 40, stomach: .light, name: "spirit"),
        ]
        store.rebuildForPreview()
        return store
    }

    private func rebuildForPreview() {
        band = BACEngine().simulateBand(profile: profile, drinks: drinks)
    }
}
