import Testing
import Foundation
@testable import BACKit

/// A várt értékek a `Reference/bac_model.py` referencia-implementációból
/// származnak, a béta 0,12 / 0,15 / 0,18 hármasával.
private let reference = BodyProfile(
    sex: .male, age: 35, heightCm: 180, weightKg: 80,
    beta: 0.15, betaUncertainty: 0.03
)
private let t0 = Date(timeIntervalSince1970: 0)
private let engine = BACEngine()

private func minute(_ m: Double) -> Date { t0.addingTimeInterval(m * 60) }

private var series: [Drink] {
    [
        Drink(consumedAt: minute(0), volumeMl: 500, abvPercent: 5, stomach: .full),
        Drink(consumedAt: minute(45), volumeMl: 500, abvPercent: 5, stomach: .light),
        Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 12, stomach: .light),
    ]
}

@Suite("Béta tartomány")
struct BetaRangeTests {

    @Test("A sáv széleit a bizonytalanság adja")
    func betaRange() {
        #expect(abs(reference.betaRange.lowerBound - 0.12) < 1e-9)
        #expect(abs(reference.betaRange.upperBound - 0.18) < 1e-9)
    }

    @Test("A tartomány nem lóg ki az élettani határokon")
    func clampedToBounds() {
        var extreme = reference
        extreme.beta = 0.10
        extreme.betaUncertainty = 0.20
        #expect(extreme.betaRange.lowerBound >= Physiology.betaBounds.lowerBound)
        #expect(extreme.betaRange.upperBound <= Physiology.betaBounds.upperBound)
    }

    @Test("Nulla bizonytalanságnál a sáv egyetlen pont")
    func zeroUncertainty() {
        var exact = reference
        exact.betaUncertainty = 0
        #expect(exact.betaRange.lowerBound == exact.betaRange.upperBound)

        let band = engine.simulateBand(profile: exact, drinks: series)
        let peak = band.peakRange!
        #expect(abs(peak.upperBound - peak.lowerBound) < 1e-6)
    }

    @Test("Régi, betaUncertainty nélküli mentés is visszaolvasható")
    func decodesLegacySnapshot() throws {
        let legacy = """
        {"sex":"male","age":35,"heightCm":180,"weightKg":80,"beta":0.15}
        """.data(using: .utf8)!

        let profile = try JSONDecoder().decode(BodyProfile.self, from: legacy)
        #expect(profile.beta == 0.15)
        #expect(profile.betaUncertainty == Physiology.defaultBetaUncertainty)
    }
}

@Suite("BAC sáv")
struct BACBandTests {

    @Test("A csúcs tartománya egyezik a referenciával")
    func peakRangeMatchesReference() throws {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let peak = try #require(band.peakRange)

        #expect(abs(peak.lowerBound - 0.510401) < 1e-4)
        #expect(abs(peak.upperBound - 0.624922) < 1e-4)

        // A középső görbe csúcsa a sávon belül van.
        let center = try #require(band.peak)
        #expect(abs(center.bac - 0.565699) < 1e-4)
        #expect(peak.contains(center.bac))
    }

    @Test("A szint tartománya egyezik a referenciával")
    func rangeAtTimeMatchesReference() {
        let band = engine.simulateBand(profile: reference, drinks: series)

        let expected: [(Double, Double, Double)] = [
            (60, 0.223210, 0.264858),
            (120, 0.498367, 0.595574),
            (180, 0.439481, 0.593382),
            (240, 0.282494, 0.491116),
        ]
        for (m, low, high) in expected {
            let range = band.range(at: minute(m))
            #expect(abs(range.lowerBound - low) < 1e-4)
            #expect(abs(range.upperBound - high) < 1e-4)
        }
    }

    @Test("A kiürülés tartománya egyezik a referenciával")
    func soberRangeMatchesReference() throws {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let sober = try #require(band.soberRange())

        #expect(abs(sober.lowerBound.timeIntervalSince(t0) / 60 - 355) < 2)
        #expect(abs(sober.upperBound.timeIntervalSince(t0) / 60 - 522) < 2)
    }

    @Test("A felső ág sehol nem megy az alsó alá")
    func bandIsOrdered() {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let violations = band.samples.filter { $0.high < $0.low - 1e-9 }
        #expect(violations.isEmpty)
    }

    @Test("A középvonal végig a sávon belül fut")
    func centerInsideBand() {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let outside = band.samples.filter { $0.mid < $0.low - 1e-6 || $0.mid > $0.high + 1e-6 }
        #expect(outside.isEmpty)
    }

    @Test("Üres bevitelre üres sáv")
    func emptyInput() {
        let band = engine.simulateBand(profile: reference, drinks: [])
        #expect(band.isEmpty)
        #expect(band.peakRange == nil)
        #expect(band.soberRange() == nil)
    }

    @Test("Nagyobb bizonytalanság szélesebb sávot ad")
    func widerUncertaintyWidensBand() throws {
        var wide = reference
        wide.betaUncertainty = 0.05

        let narrowPeak = try #require(engine.simulateBand(profile: reference, drinks: series).peakRange)
        let widePeak = try #require(engine.simulateBand(profile: wide, drinks: series).peakRange)

        let narrowWidth = narrowPeak.upperBound - narrowPeak.lowerBound
        let wideWidth = widePeak.upperBound - widePeak.lowerBound
        #expect(wideWidth > narrowWidth)
    }
}

@Suite("Határátlépés három állapota")
struct LimitOutcomeTests {

    /// A referencia szerint a csúcs sávja 0,510–0,625 g/L.
    @Test("A küszöb helyzete szerint below / uncertain / above")
    func outcomeBoundaries() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 12, stomach: .light)
        let consumed = Array(series.prefix(2))

        func outcome(limit: Double) -> LimitOutcome {
            engine.projectBand(profile: reference, consumed: consumed, candidate: candidate, limit: limit).outcome
        }

        #expect(outcome(limit: 0.40) == .above)      // még gyors lebontással is átlépi
        #expect(outcome(limit: 0.60) == .uncertain)  // csak lassú lebontással
        #expect(outcome(limit: 0.90) == .below)      // sehogy
    }

    @Test("A kimenetel monoton a küszöbben")
    func monotonicInLimit() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 12, stomach: .light)
        let consumed = Array(series.prefix(2))

        var seenBelow = false
        for step in stride(from: 0.2, through: 1.2, by: 0.05) {
            let outcome = engine.projectBand(
                profile: reference, consumed: consumed, candidate: candidate, limit: step
            ).outcome
            if outcome == .below { seenBelow = true }
            // ha egyszer már „below", magasabb küszöbnél sem lehet szigorúbb
            if seenBelow { #expect(outcome == .below) }
        }
    }

    @Test("A segédtulajdonságok konzisztensek")
    func helperFlags() {
        #expect(LimitOutcome.below.exceedsPossible == false)
        #expect(LimitOutcome.uncertain.exceedsPossible == true)
        #expect(LimitOutcome.above.exceedsPossible == true)

        #expect(LimitOutcome.below.exceedsCertain == false)
        #expect(LimitOutcome.uncertain.exceedsCertain == false)
        #expect(LimitOutcome.above.exceedsCertain == true)
    }
}

@Suite("Sávos előrejelzés")
struct BandedProjectionTests {

    @Test("A vetített csúcs tartománya a jelenlegi fölött van")
    func projectionRaisesPeak() {
        let consumed = Array(series.prefix(2))
        let candidate = Drink(consumedAt: minute(90), volumeMl: 500, abvPercent: 5)
        let p = engine.projectBand(profile: reference, consumed: consumed, candidate: candidate, limit: 1.2)

        #expect(p.peakRange.lowerBound > p.currentRange.lowerBound)
        #expect(p.timeToPeak > 0)
        #expect(p.soberRange != nil)
    }

    @Test("A nagyobb ital magasabb sávot és később kiürülést ad")
    func largerDrinkShiftsBand() throws {
        let consumed = Array(series.prefix(2))
        let small = Drink(consumedAt: minute(90), volumeMl: 40, abvPercent: 40)
        let large = Drink(consumedAt: minute(90), volumeMl: 120, abvPercent: 40)

        let ps = engine.projectBand(profile: reference, consumed: consumed, candidate: small, limit: 1.5)
        let pl = engine.projectBand(profile: reference, consumed: consumed, candidate: large, limit: 1.5)

        #expect(pl.peakRange.lowerBound > ps.peakRange.lowerBound)
        #expect(pl.peakRange.upperBound > ps.peakRange.upperBound)

        let smallSober = try #require(ps.soberRange)
        let largeSober = try #require(pl.soberRange)
        #expect(largeSober.upperBound > smallSober.upperBound)
    }

    @Test("Üres előzmény esetén a jelenlegi tartomány nulla")
    func firstDrinkOfTheSession() {
        let candidate = Drink(consumedAt: t0, volumeMl: 500, abvPercent: 5)
        let p = engine.projectBand(profile: reference, consumed: [], candidate: candidate, limit: 0.8)

        #expect(p.currentRange.lowerBound == 0)
        #expect(p.currentRange.upperBound == 0)
        #expect(p.peakRange.lowerBound > 0)
    }
}
