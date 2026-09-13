import Foundation

/// One point on the band: lower estimate, centre, upper estimate.
public struct BACBandSample: Hashable, Sendable {
    public let date: Date
    /// Assuming fast elimination.
    public let low: Double
    public let mid: Double
    /// Assuming slow elimination.
    public let high: Double

    public var range: ClosedRange<Double> { min(low, high)...max(low, high) }
}

/// Three simulations: the plausible extremes of beta plus its centre.
///
/// This, rather than a single curve, is the model's output because across its
/// own range beta shifts the peak by more than 40 % and the time to clear by
/// several hours. Drawing one line would claim a precision that is not there.
///
/// Named by where the curve sits, not by the value of beta: **slow**
/// elimination produces the **higher**, longer-lasting curve, so that one is
/// `upper`. This is easy to get backwards.
public struct BACBand: Sendable {
    /// Using the centre value of beta.
    public let center: BACCurve
    /// Slow elimination — the top of the band.
    public let upper: BACCurve
    /// Fast elimination — the bottom of the band.
    public let lower: BACCurve

    public init(center: BACCurve, upper: BACCurve, lower: BACCurve) {
        self.center = center
        self.upper = upper
        self.lower = lower
    }

    public static let empty = BACBand(
        center: BACCurve(samples: [], startedAt: .now),
        upper: BACCurve(samples: [], startedAt: .now),
        lower: BACCurve(samples: [], startedAt: .now)
    )

    public var isEmpty: Bool { center.samples.isEmpty }

    /// The merged samples, aligned to the longest curve's timestamps — the
    /// three simulations reach zero at different times.
    public var samples: [BACBandSample] {
        let spine = upper.samples.count >= center.samples.count ? upper.samples : center.samples
        return spine.map { sample in
            BACBandSample(
                date: sample.date,
                low: lower.value(at: sample.date),
                mid: center.value(at: sample.date),
                high: upper.value(at: sample.date)
            )
        }
    }

    /// The range of possible levels at a given time.
    public func range(at date: Date) -> ClosedRange<Double> {
        let a = lower.value(at: date)
        let b = upper.value(at: date)
        return min(a, b)...max(a, b)
    }

    public func value(at date: Date) -> Double {
        center.value(at: date)
    }

    /// The range of possible peaks. The two outer curves can peak at different
    /// times, so this is a range of values, not of one moment.
    public var peakRange: ClosedRange<Double>? {
        guard let low = lower.peak?.bac, let high = upper.peak?.bac else { return nil }
        return min(low, high)...max(low, high)
    }

    /// The centre curve's peak — use its timestamp when one must be shown.
    public var peak: BACSample? { center.peak }

    /// When the level clears: sooner with fast elimination, later with slow.
    public func soberRange(threshold: Double = 0.01) -> ClosedRange<Date>? {
        guard
            let early = lower.soberDate(threshold: threshold),
            let late = upper.soberDate(threshold: threshold)
        else { return nil }
        return min(early, late)...max(early, late)
    }

    /// The latest time any branch of the band extends to.
    public var end: Date? {
        [center.samples.last?.date, upper.samples.last?.date, lower.samples.last?.date]
            .compactMap { $0 }
            .max()
    }
}

// MARK: - Limit crossing

/// A three-state answer to whether a planned drink crosses the user's limit.
///
/// Because of the uncertainty there is a third case between "no" and "yes"
/// that it would be dishonest to round in either direction.
public enum LimitOutcome: Sendable, Hashable {
    /// Would not reach the limit even with slow elimination.
    case below
    /// Would cross with slow elimination but not with fast.
    case uncertain
    /// Would cross even with fast elimination.
    case above

    public var exceedsPossible: Bool { self != .below }
    public var exceedsCertain: Bool { self == .above }
}

// MARK: - Banded projection

/// The "what if I have the next one" answer, expressed as ranges.
public struct BandedProjection: Sendable {
    public let currentRange: ClosedRange<Double>
    public let peakRange: ClosedRange<Double>
    public let peakDate: Date
    public let timeToPeak: TimeInterval
    public let soberRange: ClosedRange<Date>?
    public let outcome: LimitOutcome
    /// When the limit would be crossed in the earliest case.
    public let limitCrossedAt: Date?
    /// How long it would stay above according to the slow branch — the
    /// pessimistic bound.
    public let maxTimeAboveLimit: TimeInterval
    /// The steepest rise on the centre curve, in g/L/h.
    public let peakRiseRate: Double
}

// MARK: - Engine

public extension BACEngine {

    /// Runs the simulation at three values of beta.
    func simulateBand(profile: BodyProfile, drinks: [Drink], from origin: Date? = nil) -> BACBand {
        guard !drinks.isEmpty else { return .empty }

        let bounds = profile.betaRange
        var slow = profile
        slow.beta = bounds.lowerBound
        var fast = profile
        fast.beta = bounds.upperBound

        return BACBand(
            center: simulate(profile: profile, drinks: drinks, from: origin),
            upper: simulate(profile: slow, drinks: drinks, from: origin),
            lower: simulate(profile: fast, drinks: drinks, from: origin)
        )
    }

    /// Banded counterpart of `project(profile:consumed:candidate:limit:)`.
    func projectBand(
        profile: BodyProfile,
        consumed: [Drink],
        candidate: Drink,
        limit: Double
    ) -> BandedProjection {
        let origin = (consumed.map(\.consumedAt) + [candidate.consumedAt]).min() ?? candidate.consumedAt
        let baseline = simulateBand(profile: profile, drinks: consumed, from: origin)
        let projected = simulateBand(profile: profile, drinks: consumed + [candidate], from: origin)

        func peakAfter(_ curve: BACCurve) -> BACSample? {
            curve.samples.filter { $0.date >= candidate.consumedAt }.max { $0.bac < $1.bac }
        }

        let lowPeak = peakAfter(projected.lower)?.bac ?? 0
        let highPeak = peakAfter(projected.upper)?.bac ?? 0
        let centerPeak = peakAfter(projected.center)

        let outcome: LimitOutcome =
            if lowPeak >= limit { .above }
            else if highPeak >= limit { .uncertain }
            else { .below }

        let peakDate = centerPeak?.date ?? candidate.consumedAt
        let riseRate = projected.center.samples
            .filter { $0.date >= candidate.consumedAt }
            .map(\.rate)
            .max() ?? 0

        return BandedProjection(
            currentRange: consumed.isEmpty ? 0...0 : baseline.range(at: candidate.consumedAt),
            peakRange: min(lowPeak, highPeak)...max(lowPeak, highPeak),
            peakDate: peakDate,
            timeToPeak: peakDate.timeIntervalSince(candidate.consumedAt),
            soberRange: projected.soberRange(),
            outcome: outcome,
            limitCrossedAt: projected.upper.firstCrossing(of: limit),
            maxTimeAboveLimit: projected.upper.duration(above: limit),
            peakRiseRate: riseRate
        )
    }
}
