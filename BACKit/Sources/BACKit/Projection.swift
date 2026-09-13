import Foundation

/// Annak az eredménye, hogy „mi történik, HA megiszom a következőt”.
///
/// Ez az app létezésének oka: a döntés a kiöntés ELŐTT születik, és az
/// egységszámláló trackerek csak visszamenőleg tudnak válaszolni.
public struct DrinkProjection: Sendable {
    /// A jelenlegi szint a tervezett ital időpontjában.
    public let currentBAC: Double
    /// A vetített csúcs, ha az ital megtörténik.
    public let projectedPeak: Double
    /// Mikor jönne a csúcs.
    public let projectedPeakDate: Date
    /// Mennyi idő múlva jönne a csúcs.
    public let timeToPeak: TimeInterval
    /// Mennyivel emelné a csúcsot ez az egy ital.
    public var increment: Double { projectedPeak - currentBAC }

    /// Átlépné-e a felhasználó saját határát.
    public let exceedsLimit: Bool
    /// Mikor lépné át.
    public let limitCrossedAt: Date?
    /// Mennyi ideig maradna a határ fölött.
    public let timeAboveLimit: TimeInterval
    /// Mikorra esne vissza józan szintre.
    public let soberAt: Date?

    /// A legmeredekebb emelkedés g/L/h-ban az ital után. A memóriakiesés
    /// a felszívódás sebességével korrelál, nem csak a csúcsértékkel.
    public let peakRiseRate: Double
}

public extension BACEngine {
    /// Összeveti a jelenlegi állapotot azzal, ami egy tervezett ital után következne.
    ///
    /// - Parameters:
    ///   - profile: a felhasználó testalkata
    ///   - consumed: az eddig elfogyasztott italok
    ///   - candidate: a tervezett ital
    ///   - limit: a felhasználó által beállított saját határ g/L-ben
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

    /// Megkeresi a legnagyobb italt, ami még belefér a saját határba.
    ///
    /// Bináris keresés a térfogatra — a görbe monoton a dózisban, így ez stabil.
    /// Nil, ha már a jelenlegi szint is a határ fölött van.
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
