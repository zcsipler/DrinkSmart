import Foundation

/// The answer to "what happens IF I have the next one".
///
/// This is why the app exists: the decision is made BEFORE the drink is poured,
/// and unit-counting trackers can only answer in retrospect.
///
/// Single-curve variant. `BandedProjection` is the one the UI uses, since the
/// uncertainty on the elimination rate is too large to report a single number.
public struct DrinkProjection: Sendable {
    /// The current level at the time of the planned drink.
    public let currentBAC: Double
    /// The projected peak if the drink happens.
    public let projectedPeak: Double
    /// When that peak would occur.
    public let projectedPeakDate: Date
    /// How far ahead the peak is.
    public let timeToPeak: TimeInterval
    /// How much this one drink raises the peak.
    public var increment: Double { projectedPeak - currentBAC }

    /// Whether it would cross the user's own limit.
    public let exceedsLimit: Bool
    /// When it would cross.
    public let limitCrossedAt: Date?
    /// How long it would stay above.
    public let timeAboveLimit: TimeInterval
    /// When the level would fall back to sober.
    public let soberAt: Date?

    /// The steepest rise after the drink, in g/L/h. Memory impairment tracks
    /// absorption speed, not only the peak value.
    public let peakRiseRate: Double
}

public extension BACEngine {
    /// Compares the current state with what would follow a planned drink.
    ///
    /// - Parameters:
    ///   - profile: the user's body composition
    ///   - consumed: drinks already consumed
    ///   - candidate: the planned drink
    ///   - limit: the user's own limit in g/L
    func project(
        profile: BodyProfile,
        consumed: [Drink],
        candidate: Drink,
        limit: Double
    ) -> DrinkProjection {
        let origin = (consumed.map(\.consumedAt) + [candidate.consumedAt]).min() ?? candidate.consumedAt
        let baseline = simulate(profile: profile, drinks: consumed, from: origin)
        let projected = simulate(profile: profile, drinks: consumed + [candidate], from: origin)

        let after = projected.samples.filter { $0.date >= candidate.consumedAt }
        let peak = after.max { $0.bac < $1.bac } ?? projected.peak
        let peakBAC = peak?.bac ?? 0
        let peakDate = peak?.date ?? candidate.consumedAt
        let riseRate = after.map(\.rate).max() ?? 0

        return DrinkProjection(
            currentBAC: baseline.value(at: candidate.consumedAt),
            projectedPeak: peakBAC,
            projectedPeakDate: peakDate,
            timeToPeak: peakDate.timeIntervalSince(candidate.consumedAt),
            exceedsLimit: peakBAC >= limit,
            limitCrossedAt: projected.firstCrossing(of: limit),
            timeAboveLimit: projected.duration(above: limit),
            soberAt: projected.soberDate(),
            peakRiseRate: riseRate
        )
    }

    /// Finds the largest drink that still fits under the user's own limit.
    ///
    /// Binary search on volume — the curve is monotonic in dose, so this is
    /// stable. Returns nil when the current level is already above the limit.
    func largestDrinkWithinLimit(
        profile: BodyProfile,
        consumed: [Drink],
        template: Drink,
        limit: Double,
        tolerance: Double = 1
    ) -> Double? {
        var candidate = template
        candidate.volumeMl = 0
        if project(profile: profile, consumed: consumed, candidate: candidate, limit: limit).exceedsLimit {
            return nil
        }

        var low = 0.0
        var high = max(template.volumeMl, 1000)
        while high - low > tolerance {
            let mid = (low + high) / 2
            candidate.volumeMl = mid
            if project(profile: profile, consumed: consumed, candidate: candidate, limit: limit).exceedsLimit {
                high = mid
            } else {
                low = mid
            }
        }
        return low
    }
}
