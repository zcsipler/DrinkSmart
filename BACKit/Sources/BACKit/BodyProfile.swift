import Foundation

/// Élettani állandók. Minden koncentráció g/L egységben (= ezrelék),
/// mert a forenzikus szakirodalom ebben dolgozik.
/// Átváltás: 1.0 g/L = 0.1 g/dL = 0.10 % BAC.
public enum Physiology {
    /// Etanol sűrűsége g/mL-ben.
    public static let ethanolDensity = 0.789

    /// Egy liter teljes vér víztartalma literben (80.6 % w/w × 1.055 g/mL sűrűség).
    public static let bloodWaterFraction = 0.85

    /// Michaelis–Menten Km. Ekkora érték mellett az elimináció 0.02 g/L fölött
    /// gyakorlatilag nulladrendű, nulla közelében viszont simán kifut.
    public static let michaelisConstant = 0.02

    /// Alapértelmezett eliminációs ráta, „mild to moderate drinker” átlag.
    /// Az irodalmi tartomány nagyjából 0.10–0.25 g/L/h.
    public static let defaultBeta = 0.15

    /// A béta alapértelmezett bizonytalansága (± g/L/h).
    public static let defaultBetaUncertainty = 0.03

    /// Élettanilag lehetséges szélsőértékek. A sáv soha nem lóg ezeken túl.
    public static let betaBounds = 0.08...0.32

    /// Egy standard egység tiszta alkoholban, grammban (EU/magyar konvenció).
    public static let gramsPerStandardUnit = 10.0
}

public enum Sex: String, Codable, Sendable, CaseIterable {
    case male, female
}

/// A felhasználó testalkata és anyagcseréje.
///
/// A `beta` szándékosan felhasználó által állítható: ez az egyetlen paraméter,
/// aminek a kalibrálása érdemben javítja a személyes pontosságot.
public struct BodyProfile: Codable, Hashable, Sendable {
    public var sex: Sex
    public var age: Double
    public var heightCm: Double
    public var weightKg: Double

    /// Eliminációs ráta g/L/h. A sáv középértéke.
    public var beta: Double

    /// A `beta` bizonytalansága (± g/L/h).
    ///
    /// Nem kozmetika: a béta a plauzibilis tartományán belül 40 % fölött
    /// mozgatja a csúcsot és több órát a kiürülésen, ezért a modell
    /// kimenete tartomány, nem egyetlen szám.
    public var betaUncertainty: Double

    /// Ha a felhasználó a saját teljes testvizét kalibrálta, ez felülírja a Watson-becslést.
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

    /// A lassú és a gyors lebontás széle, élettanilag lehetséges korlátok közé vágva.
    public var betaRange: ClosedRange<Double> {
        let low = max(beta - betaUncertainty, Physiology.betaBounds.lowerBound)
        let high = min(beta + betaUncertainty, Physiology.betaBounds.upperBound)
        return low...max(high, low)
    }

    /// Régi, `betaUncertainty` nélküli mentések visszaolvasásához.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sex = try c.decode(Sex.self, forKey: .sex)
        age = try c.decode(Double.self, forKey: .age)
        heightCm = try c.decode(Double.self, forKey: .heightCm)
        weightKg = try c.decode(Double.self, forKey: .weightKg)
        beta = try c.decodeIfPresent(Double.self, forKey: .beta) ?? Physiology.defaultBeta
        betaUncertainty = try c.decodeIfPresent(Double.self, forKey: .betaUncertainty)
            ?? Physiology.defaultBetaUncertainty
        totalBodyWaterOverride = try c.decodeIfPresent(Double.self, forKey: .totalBodyWaterOverride)
    }

    /// Watson (1980) teljes testvíz becslés, literben.
    ///
    /// A forenzikus irodalom ma ezt részesíti előnyben az etanol
    /// eloszlási térfogatának közvetlen becslésével szemben.
    public var totalBodyWater: Double {
        if let override = totalBodyWaterOverride { return override }
        switch sex {
        case .male:
            return 2.447 - 0.09516 * age + 0.1074 * heightCm + 0.3362 * weightKg
        case .female:
            return -2.097 + 0.1069 * heightCm + 0.2466 * weightKg
        }
    }

    /// Vér-ekvivalens eloszlási térfogat literben: `C = A / Vd`.
    public var distributionVolume: Double {
        totalBodyWater / Physiology.bloodWaterFraction
    }

    /// Tájékoztató Widmark-faktor. Összevethető a klasszikus 0.68 / 0.55 értékekkel,
    /// és jó sanity checkként szolgál a beviteli adatokra.
    public var widmarkFactor: Double {
        totalBodyWater / (Physiology.bloodWaterFraction * weightKg)
    }
}
