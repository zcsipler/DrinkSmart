import Foundation

/// Physiological constants. All concentrations are in g/L, which is identical
/// to per mille — the unit the forensic literature works in.
/// Conversion: `1.0 g/L = 0.1 g/dL = 0.10 % BAC`.
public enum Physiology {
    /// Density of ethanol in g/mL.
    public static let ethanolDensity = 0.789

    /// Litres of water in one litre of whole blood (80.6 % w/w × 1.055 g/mL density).
    public static let bloodWaterFraction = 0.85

    /// Michaelis constant. At this value elimination is effectively zero-order
    /// above 0.02 g/L, but tapers off smoothly near zero instead of jumping
    /// below it the way a plain linear Widmark model does.
    public static let michaelisConstant = 0.02

    /// Default elimination rate, the mild-to-moderate drinker average.
    /// The range reported in the literature is roughly 0.10–0.25 g/L/h.
    public static let defaultBeta = 0.15

    /// Default uncertainty on beta (± g/L/h).
    ///
    /// Zero by design. The band is honest, but it is an opt-in: a figure that
    /// arrives as a range has no fixed point to learn against, and learning
    /// what your own number feels like is the whole purpose of the app. Turn
    /// the uncertainty up in the advanced settings and every figure widens
    /// into a range again.
    public static let defaultBetaUncertainty = 0.0

    /// What a profile snapshot written before `betaUncertainty` existed meant
    /// implicitly. A stored session must keep the numbers it was recorded
    /// with, so the legacy fallback does not follow the default above.
    public static let legacyBetaUncertainty = 0.03

    /// Physiologically plausible extremes. The band never extends past these.
    public static let betaBounds = 0.08...0.32

    /// Grams of pure alcohol in one standard unit (EU convention).
    public static let gramsPerStandardUnit = 10.0
}

public enum Sex: String, Codable, Sendable, CaseIterable {
    case male, female
}

/// The user's body composition and metabolism.
///
/// `beta` is deliberately adjustable: it is the single parameter whose
/// calibration meaningfully improves accuracy for an individual.
public struct BodyProfile: Codable, Hashable, Sendable {
    public var sex: Sex
    public var age: Double
    public var heightCm: Double
    public var weightKg: Double

    /// Elimination rate in g/L/h. The centre of the band.
    public var beta: Double

    /// Uncertainty on `beta` (± g/L/h).
    ///
    /// Not cosmetic: across its plausible range beta shifts the peak by more
    /// than 40 % and the time to clear by several hours. Zero collapses the
    /// band to a line and every displayed figure to a single number, which is
    /// the default; above zero the same figures are shown as ranges.
    public var betaUncertainty: Double

    /// Overrides the Watson estimate when the user has calibrated their own
    /// total body water.
    public var totalBodyWaterOverride: Double?

    public init(
        sex: Sex,
        age: Double,
        heightCm: Double,
        weightKg: Double,
        beta: Double = Physiology.defaultBeta,
        betaUncertainty: Double = Physiology.defaultBetaUncertainty,
        totalBodyWaterOverride: Double? = nil
    ) {
        self.sex = sex
        self.age = age
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.beta = beta
        self.betaUncertainty = betaUncertainty
        self.totalBodyWaterOverride = totalBodyWaterOverride
    }

    /// Watson (1980) total body water estimate, in litres.
    ///
    /// Current forensic practice prefers this over estimating ethanol's
    /// volume of distribution directly.
    ///
    /// Note that the female equation does not include age. That is a property
    /// of the Watson equations, not an omission here.
    public var totalBodyWater: Double {
        if let override = totalBodyWaterOverride { return override }
        switch sex {
        case .male:
            return 2.447 - 0.09516 * age + 0.1074 * heightCm + 0.3362 * weightKg
        case .female:
            return -2.097 + 0.1069 * heightCm + 0.2466 * weightKg
        }
    }

    /// Blood-equivalent volume of distribution in litres: `C = A / Vd`.
    public var distributionVolume: Double {
        totalBodyWater / Physiology.bloodWaterFraction
    }

    /// Informational Widmark factor. Comparable to the classic 0.68 / 0.55
    /// values, which makes it a useful sanity check on the entered body data.
    public var widmarkFactor: Double {
        totalBodyWater / (Physiology.bloodWaterFraction * weightKg)
    }

    /// The slow and fast ends of elimination, clamped to physiological bounds.
    public var betaRange: ClosedRange<Double> {
        let low = max(beta - betaUncertainty, Physiology.betaBounds.lowerBound)
        let high = min(beta + betaUncertainty, Physiology.betaBounds.upperBound)
        return low...max(high, low)
    }

    /// Decodes snapshots written before `betaUncertainty` existed.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sex = try c.decode(Sex.self, forKey: .sex)
        age = try c.decode(Double.self, forKey: .age)
        heightCm = try c.decode(Double.self, forKey: .heightCm)
        weightKg = try c.decode(Double.self, forKey: .weightKg)
        beta = try c.decodeIfPresent(Double.self, forKey: .beta) ?? Physiology.defaultBeta
        betaUncertainty = try c.decodeIfPresent(Double.self, forKey: .betaUncertainty)
            ?? Physiology.legacyBetaUncertainty
        totalBodyWaterOverride = try c.decodeIfPresent(Double.self, forKey: .totalBodyWaterOverride)
    }
}
