import Foundation

/// Gyomortartalom az ital elfogyasztásának pillanatában.
///
/// Ez a modell legérzékenyebb bemenete a testalkat után: a felszívódás
/// sebességét és a gyomri first-pass metabolizmust is ez vezérli.
public enum StomachState: String, Codable, Sendable, CaseIterable {
    case empty, light, full

    /// Elsőrendű felszívódási ráta-konstans, 1/h.
    /// Éhgyomorra a felszívódási felezési idő ~7 perc, teli gyomorra ~35 perc.
    public var absorptionRatePerHour: Double {
        switch self {
        case .empty: 6.0
        case .light: 2.5
        case .full:  1.2
        }
    }

    /// Biohasznosulás. A lassabb gyomorürülés hosszabb gyomri tartózkodást,
    /// és így nagyobb ADH-általi first-pass veszteséget jelent.
    public var bioavailability: Double {
        switch self {
        case .empty: 0.95
        case .light: 0.88
        case .full:  0.80
        }
    }

    public var absorptionRatePerMinute: Double { absorptionRatePerHour / 60 }
}

/// Egy elfogyasztott vagy tervezett ital.
public struct Drink: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var consumedAt: Date
    public var volumeMl: Double
    public var abvPercent: Double
    public var stomach: StomachState
    public var name: String?

    public init(
        id: UUID = UUID(),
        consumedAt: Date,
        volumeMl: Double,
        abvPercent: Double,
        stomach: StomachState = .light,
        name: String? = nil
    ) {
        self.id = id
        self.consumedAt = consumedAt
        self.volumeMl = volumeMl
        self.abvPercent = abvPercent
        self.stomach = stomach
        self.name = name
    }

    /// Tiszta etanol grammban.
    public var gramsEthanol: Double {
        volumeMl * (abvPercent / 100) * Physiology.ethanolDensity
    }

    /// A keringésbe ténylegesen bejutó mennyiség, first-pass veszteség után.
    public var absorbedGrams: Double {
        gramsEthanol * stomach.bioavailability
    }

    /// Standard egység (10 g tiszta alkohol).
    public var standardUnits: Double {
        gramsEthanol / Physiology.gramsPerStandardUnit
    }
}

public extension Drink {
    /// Gyakori italtípusok gyors felvitelhez.
    static func beer(_ ml: Double = 500, abv: Double = 5, at date: Date, stomach: StomachState = .light) -> Drink {
        Drink(consumedAt: date, volumeMl: ml, abvPercent: abv, stomach: stomach, name: "Sör")
    }

    static func wine(_ ml: Double = 150, abv: Double = 12, at date: Date, stomach: StomachState = .light) -> Drink {
        Drink(consumedAt: date, volumeMl: ml, abvPercent: abv, stomach: stomach, name: "Bor")
    }

    static func spirit(_ ml: Double = 40, abv: Double = 40, at date: Date, stomach: StomachState = .light) -> Drink {
        Drink(consumedAt: date, volumeMl: ml, abvPercent: abv, stomach: stomach, name: "Tömény")
    }
}
