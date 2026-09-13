import Foundation

/// Egy időpont a sávon: alsó becslés, középérték, felső becslés.
public struct BACBandSample: Hashable, Sendable {
    public let date: Date
    /// Gyors lebontást feltételezve.
    public let low: Double
    public let mid: Double
    /// Lassú lebontást feltételezve.
    public let high: Double

    public var range: ClosedRange<Double> { min(low, high)...max(low, high) }
}

/// Három szimuláció a béta plauzibilis széleivel és a középértékével.
///
/// Azért ez a modell kimenete egyetlen görbe helyett, mert a béta a saját
/// tartományán belül 40 % fölött mozgatja a csúcsot és több órát a kiürülésen.
/// Egy vonal kirajzolása olyan pontosságot állítana, ami nincs.
///
/// Elnevezés a görbe helyzete szerint, nem a bétáé szerint: a **lassú**
/// lebontás ad **magasabb** és tovább tartó görbét, tehát az a `upper`.
public struct BACBand: Sendable {
    /// A béta középértékével.
    public let center: BACCurve
    /// Lassú lebontás — a sáv teteje.
    public let upper: BACCurve
    /// Gyors lebontás — a sáv alja.
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

    /// Az összefésült minták. A leghosszabb görbe időpontjaira illesztve,
    /// mert a három szimuláció különböző időben fut ki nullára.
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

    /// A szint tartománya egy adott időpontban.
    public func range(at date: Date) -> ClosedRange<Double> {
        let a = lower.value(at: date)
        let b = upper.value(at: date)
        return min(a, b)...max(a, b)
    }

    public func value(at date: Date) -> Double {
        center.value(at: date)
    }

    /// A csúcs tartománya. A két szélső görbe csúcsa eltérő időpontra is eshet.
    public var peakRange: ClosedRange<Double>? {
        guard let low = lower.peak?.bac, let high = upper.peak?.bac else { return nil }
        return min(low, high)...max(low, high)
    }

    /// A középső görbe csúcsa — ennek az időpontját érdemes kiírni.
    public var peak: BACSample? { center.peak }

    /// Mikorra ürül ki. Gyors lebontással hamarabb, lassúval később.
    public func soberRange(threshold: Double = 0.01) -> ClosedRange<Date>? {
        guard
            let early = lower.soberDate(threshold: threshold),
            let late = upper.soberDate(threshold: threshold)
        else { return nil }
        return min(early, late)...max(early, late)
    }

    /// A legkésőbbi időpont, ameddig a sáv bármelyik ága tart.
    public var end: Date? {
        [center.samples.last?.date, upper.samples.last?.date, lower.samples.last?.date]
            .compactMap { $0 }
            .max()
    }
}

// MARK: - Határátlépés

/// Háromállapotú válasz arra, hogy egy tervezett ital átvinne-e a saját határon.
///
/// A bizonytalanság miatt a „nem" és az „igen" közt van egy harmadik eset,
/// amit tisztességtelen lenne bármelyik irányba kerekíteni.
public enum LimitOutcome: Sendable, Hashable {
    /// A lassú lebontás esetén sem érné el a határt.
    case below
    /// A lassú lebontásnál átlépné, a gyorsnál nem.
    case uncertain
    /// Még gyors lebontással is átlépné.
    case above

    public var exceedsPossible: Bool { self != .below }
    public var exceedsCertain: Bool { self == .above }
}

// MARK: - Sávos előrejelzés

/// A „mi lenne, ha megiszom a következőt" kérdés válasza, tartományokkal.
public struct BandedProjection: Sendable {
    public let currentRange: ClosedRange<Double>
    public let peakRange: ClosedRange<Double>
    public let peakDate: Date
    public let timeToPeak: TimeInterval
    public let soberRange: ClosedRange<Date>?
    public let outcome: LimitOutcome
    /// Mikor lépné át a határt a leggyorsabb esetben.
    public let limitCrossedAt: Date?
    /// Meddig maradna fölötte a lassú lebontás szerint — a pesszimista ág.
    public let maxTimeAboveLimit: TimeInterval
    /// A legmeredekebb emelkedés a középső görbén, g/L/h.
    public let peakRiseRate: Double
}

// MARK: - Motor

public extension BACEngine {

    /// Lefuttatja a szimulációt a béta három értékével.
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

    /// Sávos változata a `project(profile:consumed:candidate:limit:)` hívásnak.
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
