import Foundation

/// Stomach contents at the moment the drink is consumed.
///
/// After body composition this is the model's most sensitive input: it drives
/// both the absorption rate and gastric first-pass metabolism.
public enum StomachState: String, Codable, Sendable, CaseIterable {
    case empty, light, full

    /// First-order absorption rate constant, per hour.
    /// Absorption half-life is roughly 7 minutes on an empty stomach and
    /// around 35 minutes on a full one.
    public var absorptionRatePerHour: Double {
        switch self {
        case .empty: 6.0
        case .light: 2.5
        case .full:  1.2
        }
    }

    /// Bioavailability. Slower gastric emptying means a longer residence time
    /// in the stomach, and therefore greater first-pass loss to gastric ADH.
    public var bioavailability: Double {
        switch self {
        case .empty: 0.95
        case .light: 0.88
        case .full:  0.80
        }
    }

    public var absorptionRatePerMinute: Double { absorptionRatePerHour / 60 }
}

/// A consumed or planned drink.
public struct Drink: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID

    /// When drinking **started**. With a non-zero `drinkingMinutes` the dose
    /// keeps arriving after this moment.
    public var consumedAt: Date

    public var volumeMl: Double
    public var abvPercent: Double
    public var stomach: StomachState

    /// How long the drink takes to finish, in minutes. Zero means downed in
    /// one go.
    ///
    /// Across a whole evening this barely moves the peak — around 2 % for four
    /// beers, because first-order absorption already spreads each dose over
    /// 20–30 minutes. What it moves is the **rate of rise**: those same four
    /// beers go from 0.81 to 0.36 g/L/h at the steepest point when each is
    /// sipped over half an hour. Memory impairment tracks the rate rather than
    /// the peak, so that is what this exists for.
    public var drinkingMinutes: Double

    /// Free-form label. The app stores the drink template's identifier here so
    /// that persisted data does not become tied to a display language.
    public var name: String?

    public init(
        id: UUID = UUID(),
        consumedAt: Date,
        volumeMl: Double,
        abvPercent: Double,
        stomach: StomachState = .light,
        drinkingMinutes: Double = 0,
        name: String? = nil
    ) {
        self.id = id
        self.consumedAt = consumedAt
        self.volumeMl = volumeMl
        self.abvPercent = abvPercent
        self.stomach = stomach
        self.drinkingMinutes = max(drinkingMinutes, 0)
        self.name = name
    }

    /// Decodes drinks written before the duration existed as instantaneous.
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        consumedAt = try c.decode(Date.self, forKey: .consumedAt)
        volumeMl = try c.decode(Double.self, forKey: .volumeMl)
        abvPercent = try c.decode(Double.self, forKey: .abvPercent)
        stomach = try c.decodeIfPresent(StomachState.self, forKey: .stomach) ?? .light
        drinkingMinutes = try c.decodeIfPresent(Double.self, forKey: .drinkingMinutes) ?? 0
        name = try c.decodeIfPresent(String.self, forKey: .name)
    }

    /// When the last sip goes down.
    public var finishedAt: Date {
        consumedAt.addingTimeInterval(drinkingMinutes * 60)
    }

    /// Pure ethanol in grams.
    public var gramsEthanol: Double {
        volumeMl * (abvPercent / 100) * Physiology.ethanolDensity
    }

    /// The amount that actually reaches the circulation, after first-pass loss.
    public var absorbedGrams: Double {
        gramsEthanol * stomach.bioavailability
    }

    /// Standard units (10 g of pure alcohol each).
    public var standardUnits: Double {
        gramsEthanol / Physiology.gramsPerStandardUnit
    }
}

public extension Drink {
    /// Convenience constructors for common drink types.
    static func beer(_ ml: Double = 500, abv: Double = 5, at date: Date,
                      stomach: StomachState = .light, over minutes: Double = 0) -> Drink {
        Drink(consumedAt: date, volumeMl: ml, abvPercent: abv, stomach: stomach,
              drinkingMinutes: minutes, name: "beer")
    }

    static func wine(_ ml: Double = 150, abv: Double = 12, at date: Date,
                      stomach: StomachState = .light, over minutes: Double = 0) -> Drink {
        Drink(consumedAt: date, volumeMl: ml, abvPercent: abv, stomach: stomach,
              drinkingMinutes: minutes, name: "wine")
    }

    static func spirit(_ ml: Double = 40, abv: Double = 40, at date: Date,
                      stomach: StomachState = .light, over minutes: Double = 0) -> Drink {
        Drink(consumedAt: date, volumeMl: ml, abvPercent: abv, stomach: stomach,
              drinkingMinutes: minutes, name: "spirit")
    }
}
