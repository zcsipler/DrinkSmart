import Foundation
import Observation
import BACKit

/// Az app egyetlen állapotforrása.
///
/// A sávot csak akkor számolja újra, amikor a bemenet tényleg változik
/// (ital, profil) — az óra ketyegése csak a `now`-t mozgatja, ami a
/// leolvasást frissíti, de nem indít új szimulációt.
@Observable
final class SessionStore {

    // MARK: Állapot

    var profile: BodyProfile {
        didSet { rebuild(); persist() }
    }

    /// A felhasználó saját határa g/L-ben. Nem jogi limit — személyes referencia.
    var limit: Double {
        didSet { persist() }
    }

    var unit: BACUnit {
        didSet { persist() }
    }

    /// A béta proxyja. Ennek az állítása írja át a profil béta értékeit.
    var frequency: DrinkingFrequency {
        didSet {
            guard frequency != oldValue else { return }
            frequency.apply(to: &profile)   // a profil didSet-je újraszámol és ment
        }
    }

    private(set) var drinks: [Drink] = []
    private(set) var band: BACBand = .empty

    /// A jelenlegi idő. Percenként frissül.
    var now: Date = .now

    private let engine = BACEngine()

    // MARK: Élettartam

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

    // MARK: Származtatott értékek

    /// A jelenlegi szint tartománya. Ez a fő kijelző adata.
    var currentRange: ClosedRange<Double> {
        drinks.isEmpty ? 0...0 : band.range(at: now)
    }

    /// A középérték — ott kell, ahol egyetlen szám muszáj (színezés, animáció).
    var currentBAC: Double {
        drinks.isEmpty ? 0 : band.value(at: now)
    }

    var peakRange: ClosedRange<Double>? { band.peakRange }
    var peak: BACSample? { band.peak }

    /// A csúcs csak akkor „várható", ha még előttünk van.
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

    /// A görbe emelkedik-e éppen. A felszálló ág az, ahol a szonda alulmérne.
    var isRising: Bool {
        !drinks.isEmpty && currentRate > 0.01
    }

    var currentRate: Double {
        band.center.samples.last { $0.date <= now }?.rate ?? 0
    }

    /// A megjelenítendő időablak. Legalább hat óra, de a teljes kiürülést befogja.
    var visibleRange: ClosedRange<Date> {
        let start = (sessionStart ?? now).addingTimeInterval(-15 * 60)
        let naturalEnd = soberRange?.upperBound ?? now.addingTimeInterval(4 * 3600)
        let end = max(naturalEnd.addingTimeInterval(20 * 60), start.addingTimeInterval(6 * 3600))
        return start...end
    }

    var yMaximum: Double {
        max((peakRange?.upperBound ?? 0) * 1.3, limit * 1.4, 0.5)
    }

    // MARK: Műveletek

    func add(_ drink: Drink) {
        drinks.append(drink)
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

    /// Mi történne, ha a felhasználó meginná ezt az italt.
    func project(_ candidate: Drink) -> BandedProjection {
        engine.projectBand(profile: profile, consumed: drinks, candidate: candidate, limit: limit)
    }

    func tick() {
        now = .now
    }

    private func rebuild() {
        band = drinks.isEmpty ? .empty : engine.simulateBand(profile: profile, drinks: drinks)
    }

    // MARK: Perzisztencia
    //
    // Egyelőre UserDefaults + Codable. A SwiftData réteg akkor kerül be,
    // amikor a korábbi alkalmak statisztikája is kell.

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
        // Csak az elmúlt 24 óra italait tartjuk meg — ami régebbi, az már kiürült.
        let cutoff = Date.now.addingTimeInterval(-24 * 3600)
        drinks = snapshot.drinks.filter { $0.consumedAt > cutoff }.sorted { $0.consumedAt < $1.consumedAt }
    }
}

// MARK: - Előnézeti adat

extension SessionStore {
    static var preview: SessionStore {
        let store = SessionStore()
        // A `name` a sablon azonosítóját hordozza, nem a megjelenített nevet.
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
