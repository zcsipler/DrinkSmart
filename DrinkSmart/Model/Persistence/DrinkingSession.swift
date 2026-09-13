import Foundation
import SwiftData
import BACKit

/// One drinking occasion, from the first drink until the level has cleared.
///
/// A session is **not** a calendar day: an evening that runs past midnight is
/// one session.
///
/// ## Why the profile is stored here
///
/// The curve is a pure function of (drinks, profile). If we kept only the
/// drinks and always recomputed with the *current* profile, every past session
/// would be redrawn whenever the user's weight changed — the same three drinks
/// peak at 0.578 g/L at 60 kg and 0.507 g/L at 70 kg, a 14 % difference. A
/// record that rewrites itself is not a record.
///
/// So each session carries the profile that was in effect. A closed session is
/// frozen; an open one tracks the current profile until it closes, because a
/// correction made mid-evening should fix the curve you are looking at.
///
/// The engine is deliberately *not* frozen: the inputs are stored, so a later
/// improvement to the model can recompute old sessions correctly.
///
/// ## CloudKit constraints
///
/// Every property has a default value or is optional, there are no unique
/// attributes, and the relationship is optional with an inverse. CloudKit
/// requires all of this, and retrofitting it later means a migration.
@Model
final class DrinkingSession {
    var id: UUID = UUID()
    var startedAt: Date = Date.now

    /// Nil while the session is still running.
    var endedAt: Date?

    // MARK: Profile snapshot
    //
    // Flattened rather than a Codable blob: CloudKit is happiest with scalars,
    // the values are readable in the debugger, and a diff shows what changed.

    var sexRaw: String = Sex.male.rawValue
    var age: Double = 35
    var heightCm: Double = 180
    var weightKg: Double = 80
    var beta: Double = Physiology.defaultBeta
    var betaUncertainty: Double = Physiology.defaultBetaUncertainty

    /// The personal limit as it stood for this session.
    var limit: Double = 0.8

    // MARK: Drinks

    @Relationship(deleteRule: .cascade, inverse: \DrinkRecord.session)
    var drinks: [DrinkRecord]? = []

    // MARK: Cached summary
    //
    // Never the truth — always recomputable from the drinks and the snapshot.
    // Stored only so that listing a year of history does not run hundreds of
    // simulations while the user scrolls.

    var cachedPeakLow: Double?
    var cachedPeakHigh: Double?
    var cachedSoberAt: Date?
    var cachedTotalUnits: Double?
    var cachedEngineVersion: Int?

    init(
        id: UUID = UUID(),
        startedAt: Date = .now,
        endedAt: Date? = nil,
        profile: BodyProfile,
        limit: Double
    ) {
        self.id = id
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.limit = limit
        self.drinks = []
        applySnapshot(of: profile)
    }

    // MARK: Profile access

    /// The profile this session was recorded with.
    var profile: BodyProfile {
        BodyProfile(
            sex: Sex(rawValue: sexRaw) ?? .male,
            age: age,
            heightCm: heightCm,
            weightKg: weightKg,
            beta: beta,
            betaUncertainty: betaUncertainty
        )
    }

    /// Overwrites the snapshot. Only legitimate while the session is open, or
    /// as an explicit correction of a past session by the user.
    func applySnapshot(of profile: BodyProfile) {
        sexRaw = profile.sex.rawValue
        age = profile.age
        heightCm = profile.heightCm
        weightKg = profile.weightKg
        beta = profile.beta
        betaUncertainty = profile.betaUncertainty
        invalidateSummary()
    }

    // MARK: Derived

    var isOpen: Bool { endedAt == nil }

    var sortedDrinks: [Drink] {
        (drinks ?? [])
            .map(\.asDrink)
            .sorted { $0.consumedAt < $1.consumedAt }
    }

    var lastDrinkAt: Date? {
        (drinks ?? []).map(\.consumedAt).max()
    }

    var totalUnits: Double {
        sortedDrinks.reduce(0) { $0 + $1.standardUnits }
    }

    // MARK: Summary cache

    /// The stored summary, or nil when it is missing or was produced by an
    /// older version of the engine.
    var summary: SessionSummary? {
        guard
            cachedEngineVersion == BACEngine.version,
            let low = cachedPeakLow,
            let high = cachedPeakHigh,
            let units = cachedTotalUnits
        else { return nil }

        return SessionSummary(
            peakRange: min(low, high)...max(low, high),
            soberAt: cachedSoberAt,
            totalUnits: units,
            drinkCount: drinks?.count ?? 0
        )
    }

    func store(_ summary: SessionSummary) {
        cachedPeakLow = summary.peakRange.lowerBound
        cachedPeakHigh = summary.peakRange.upperBound
        cachedSoberAt = summary.soberAt
        cachedTotalUnits = summary.totalUnits
        cachedEngineVersion = BACEngine.version
    }

    func invalidateSummary() {
        cachedEngineVersion = nil
    }
}

/// The few numbers a history list needs, without redrawing the curve.
struct SessionSummary: Hashable, Sendable {
    let peakRange: ClosedRange<Double>
    let soberAt: Date?
    let totalUnits: Double
    let drinkCount: Int
}
