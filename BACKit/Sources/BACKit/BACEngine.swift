import Foundation

/// One sample on the BAC curve.
public struct BACSample: Hashable, Sendable {
    /// Absolute timestamp — usable directly as a Swift Charts x value.
    public let date: Date
    /// Blood alcohol concentration in g/L (= per mille).
    public let bac: Double
    /// Signed rate of change in g/L/h. Positive means the absorption limb.
    public let rate: Double
}

/// The result of a simulation.
public struct BACCurve: Sendable {
    public let samples: [BACSample]
    public let startedAt: Date

    public init(samples: [BACSample], startedAt: Date) {
        self.samples = samples
        self.startedAt = startedAt
    }

    public var isEmpty: Bool { samples.allSatisfy { $0.bac <= 0 } }

    /// The highest point on the curve.
    public var peak: BACSample? {
        samples.max { $0.bac < $1.bac }
    }

    /// The steepest rise. Memory impairment correlates with this better than
    /// with the total amount consumed.
    public var steepestRise: BACSample? {
        samples.max { $0.rate < $1.rate }
    }

    /// Linearly interpolated value at an arbitrary time.
    public func value(at date: Date) -> Double {
        guard let first = samples.first, let last = samples.last else { return 0 }
        if date <= first.date { return first.bac }
        if date >= last.date { return last.bac }

        var low = 0, high = samples.count - 1
        while high - low > 1 {
            let mid = (low + high) / 2
            if samples[mid].date <= date { low = mid } else { high = mid }
        }
        let a = samples[low], b = samples[high]
        let span = b.date.timeIntervalSince(a.date)
        guard span > 0 else { return a.bac }
        let w = date.timeIntervalSince(a.date) / span
        return a.bac + w * (b.bac - a.bac)
    }

    /// The first time after the peak at which the level drops below `threshold`.
    public func soberDate(threshold: Double = 0.01) -> Date? {
        guard let peak else { return nil }
        return samples.first { $0.date >= peak.date && $0.bac < threshold }?.date
    }

    /// The first time the curve reaches the given limit.
    public func firstCrossing(of limit: Double) -> Date? {
        samples.first { $0.bac >= limit }?.date
    }

    /// How long the level stays above the given limit.
    public func duration(above limit: Double) -> TimeInterval {
        let above = samples.filter { $0.bac >= limit }
        guard let first = above.first, let last = above.last else { return 0 }
        return last.date.timeIntervalSince(first.date)
    }
}

/// One-compartment pharmacokinetic model with a separate gut compartment per drink.
///
/// ```
/// dGᵢ/dt = -kaᵢ · Gᵢ
/// dC/dt  = (Σᵢ kaᵢ · Gᵢ) / Vd − β · C / (Km + C)
/// ```
///
/// Integrated with RK4, because the saturable elimination term makes a plain
/// Euler step noticeably underestimate at low concentrations.
///
/// The type is deliberately a pure value and free of UI concerns: SwiftData
/// `@Model` classes call into this, never the other way round.
public struct BACEngine: Sendable {

    /// Bumped whenever a change to the model would alter the numbers it
    /// produces for the same inputs.
    ///
    /// Stored summaries carry the version they were computed with, so a model
    /// improvement invalidates them instead of silently leaving stale figures
    /// in the history. Do not bump it for refactors that keep the output
    /// identical — that would needlessly recompute every past session.
    public static let version = 1

    /// Integration step in minutes.
    public var stepMinutes: Double
    /// Sampling interval in minutes.
    public var sampleEveryMinutes: Double
    /// Maximum simulated span in minutes.
    public var horizonMinutes: Double

    public init(
        stepMinutes: Double = 0.25,
        sampleEveryMinutes: Double = 1,
        horizonMinutes: Double = 24 * 60
    ) {
        self.stepMinutes = stepMinutes
        self.sampleEveryMinutes = sampleEveryMinutes
        self.horizonMinutes = horizonMinutes
    }

    public func simulate(profile: BodyProfile, drinks: [Drink], from origin: Date? = nil) -> BACCurve {
        let ordered = drinks.sorted { $0.consumedAt < $1.consumedAt }
        guard let start = origin ?? ordered.first?.consumedAt else {
            return BACCurve(samples: [], startedAt: Date())
        }

        let vd = profile.distributionVolume
        let betaPerMinute = profile.beta / 60
        let km = Physiology.michaelisConstant

        let offsets = ordered.map { $0.consumedAt.timeIntervalSince(start) / 60 }
        let ka = ordered.map(\.stomach.absorptionRatePerMinute)
        let doses = ordered.map(\.absorbedGrams)

        var gut = [Double](repeating: 0, count: ordered.count)
        var pending = Set(ordered.indices)
        var concentration = 0.0

        /// Derivatives of the gut compartments and the central concentration.
        func derivatives(_ gutState: [Double], _ c: Double) -> ([Double], Double) {
            var dGut = [Double](repeating: 0, count: gutState.count)
            var influx = 0.0
            for i in gutState.indices {
                let flow = ka[i] * gutState[i]
                dGut[i] = -flow
                influx += flow
            }
            let elimination = c > 0 ? betaPerMinute * c / (km + c) : 0
            return (dGut, influx / vd - elimination)
        }

        var samples: [BACSample] = []
        var t = 0.0
        var nextSample = 0.0
        let dt = stepMinutes

        while t <= horizonMinutes + 1e-9 {
            // drinks consumed by now enter the stomach
            let arrived = pending.filter { offsets[$0] <= t + 1e-9 }
            for i in arrived {
                gut[i] += doses[i]
                pending.remove(i)
            }

            if t >= nextSample - 1e-9 {
                let (_, rate) = derivatives(gut, concentration)
                samples.append(BACSample(
                    date: start.addingTimeInterval(t * 60),
                    bac: max(concentration, 0),
                    rate: rate * 60
                ))
                nextSample += sampleEveryMinutes
            }

            let (k1g, k1c) = derivatives(gut, concentration)
            let g2 = zip(gut, k1g).map { $0 + 0.5 * dt * $1 }
            let (k2g, k2c) = derivatives(g2, concentration + 0.5 * dt * k1c)
            let g3 = zip(gut, k2g).map { $0 + 0.5 * dt * $1 }
            let (k3g, k3c) = derivatives(g3, concentration + 0.5 * dt * k2c)
            let g4 = zip(gut, k3g).map { $0 + dt * $1 }
            let (k4g, k4c) = derivatives(g4, concentration + dt * k3c)

            for i in gut.indices {
                gut[i] = max(gut[i] + dt / 6 * (k1g[i] + 2 * k2g[i] + 2 * k3g[i] + k4g[i]), 0)
            }
            concentration = max(concentration + dt / 6 * (k1c + 2 * k2c + 2 * k3c + k4c), 0)
            t += dt

            // early exit once nothing is left to absorb or eliminate
            if concentration <= 1e-6, pending.isEmpty, gut.allSatisfy({ $0 <= 1e-9 }), t > 1 {
                samples.append(BACSample(date: start.addingTimeInterval(t * 60), bac: 0, rate: 0))
                break
            }
        }

        return BACCurve(samples: samples, startedAt: start)
    }
}
