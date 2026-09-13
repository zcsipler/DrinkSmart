import Foundation

/// Egy mintavételi pont a BAC-görbén.
public struct BACSample: Hashable, Sendable {
    /// Abszolút időpont — közvetlenül használható Swift Charts x tengelyeként.
    public let date: Date
    /// Véralkoholszint g/L-ben (= ezrelék).
    public let bac: Double
    /// Előjeles változási sebesség g/L/h-ban. Pozitív = felszálló ág.
    public let rate: Double
}

/// A szimuláció eredménye.
public struct BACCurve: Sendable {
    public let samples: [BACSample]
    public let startedAt: Date

    public init(samples: [BACSample], startedAt: Date) {
        self.samples = samples
        self.startedAt = startedAt
    }

    public var isEmpty: Bool { samples.allSatisfy { $0.bac <= 0 } }

    /// A legmagasabb pont a görbén.
    public var peak: BACSample? {
        samples.max { $0.bac < $1.bac }
    }

    /// A legmeredekebb emelkedés. A blackout-kockázat ezzel korrelál
    /// jobban, mint a puszta összmennyiséggel.
    public var steepestRise: BACSample? {
        samples.max { $0.rate < $1.rate }
    }

    /// Lineárisan interpolált érték tetszőleges időpontban.
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

    /// Az első időpont a csúcs után, ahol a szint a küszöb alá esik.
    public func soberDate(threshold: Double = 0.01) -> Date? {
        guard let peak else { return nil }
        return samples.first { $0.date >= peak.date && $0.bac < threshold }?.date
    }

    /// Az első időpont, amikor a görbe eléri a megadott határt.
    public func firstCrossing(of limit: Double) -> Date? {
        samples.first { $0.bac >= limit }?.date
    }

    /// Mennyi ideig marad a szint a megadott határ fölött.
    public func duration(above limit: Double) -> TimeInterval {
        let above = samples.filter { $0.bac >= limit }
        guard let first = above.first, let last = above.last else { return 0 }
        return last.date.timeIntervalSince(first.date)
    }
}

/// Egy-kompartmentes farmakokinetikai modell, italonként külön gyomor-kompartmenttel.
///
/// ```
/// dGᵢ/dt = -kaᵢ · Gᵢ
/// dC/dt  = (Σᵢ kaᵢ · Gᵢ) / Vd − β · C / (Km + C)
/// ```
///
/// RK4 integrációval, mert a telíthető eliminációs tag miatt az Euler-lépés
/// alacsony BAC-nál érzékelhetően alulbecsül.
///
/// A típus szándékosan tiszta érték-szemantikájú és UI-független:
/// SwiftData `@Model` osztályok ezt hívják, nem fordítva.
public struct BACEngine: Sendable {
    /// Integrációs lépésköz percben.
    public var stepMinutes: Double
    /// Mintavételi sűrűség percben.
    public var sampleEveryMinutes: Double
    /// Maximális szimulált időtáv percben.
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

        /// Visszaadja a gyomor-kompartmentek és a központi koncentráció deriváltjait.
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
            // az aktuális időpontig elfogyasztott italok bekerülnek a gyomorba
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

            // korai kilépés, ha már nincs se felszívódó, se keringő alkohol
            if concentration <= 1e-6, pending.isEmpty, gut.allSatisfy({ $0 <= 1e-9 }), t > 1 {
                samples.append(BACSample(date: start.addingTimeInterval(t * 60), bac: 0, rate: 0))
                break
            }
        }

        return BACCurve(samples: samples, startedAt: start)
    }
}
