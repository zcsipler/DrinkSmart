import Testing
import Foundation
@testable import BACKit

/// Expected values come from `Reference/bac_model.py`, run at beta
/// 0.12 / 0.15 / 0.18.
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

@Suite("Beta range")
struct BetaRangeTests {

    @Test("Uncertainty sets the edges of the band")
    func betaRange() {
        #expect(abs(reference.betaRange.lowerBound - 0.12) < 1e-9)
        #expect(abs(reference.betaRange.upperBound - 0.18) < 1e-9)
    }

    @Test("The range stays inside the physiological bounds")
    func clampedToBounds() {
        var extreme = reference
        extreme.beta = 0.10
        extreme.betaUncertainty = 0.20
        #expect(extreme.betaRange.lowerBound >= Physiology.betaBounds.lowerBound)
        #expect(extreme.betaRange.upperBound <= Physiology.betaBounds.upperBound)
    }

    @Test("Zero uncertainty collapses the band to a point")
    func zeroUncertainty() {
        var exact = reference
        exact.betaUncertainty = 0
        #expect(exact.betaRange.lowerBound == exact.betaRange.upperBound)

        let band = engine.simulateBand(profile: exact, drinks: series)
        let peak = band.peakRange!
        #expect(abs(peak.upperBound - peak.lowerBound) < 1e-6)
    }

    @Test("A fresh profile has no uncertainty, so every figure is a point")
    func defaultIsCertain() {
        let fresh = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
        #expect(fresh.betaUncertainty == 0)
        #expect(fresh.betaRange.lowerBound == fresh.betaRange.upperBound)

        let band = engine.simulateBand(profile: fresh, drinks: series)
        #expect(band.peakRange!.lowerBound == band.peakRange!.upperBound)
    }

    @Test("Snapshots written before betaUncertainty still decode")
    func decodesLegacySnapshot() throws {
        let legacy = """
        {"sex":"male","age":35,"heightCm":180,"weightKg":80,"beta":0.15}
        """.data(using: .utf8)!

        let profile = try JSONDecoder().decode(BodyProfile.self, from: legacy)
        #expect(profile.beta == 0.15)
        // Not the default: a snapshot keeps the spread it was written with.
        #expect(profile.betaUncertainty == Physiology.legacyBetaUncertainty)
    }
}

@Suite("BAC band")
struct BACBandTests {

    @Test("The peak range matches the reference")
    func peakRangeMatchesReference() throws {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let peak = try #require(band.peakRange)

        #expect(abs(peak.lowerBound - 0.510401) < 1e-4)
        #expect(abs(peak.upperBound - 0.624922) < 1e-4)

        // The centre curve's peak lies inside the band.
        let center = try #require(band.peak)
        #expect(abs(center.bac - 0.565699) < 1e-4)
        #expect(peak.contains(center.bac))
    }

    @Test("The level range at a given time matches the reference")
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

    @Test("The sober range matches the reference")
    func soberRangeMatchesReference() throws {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let sober = try #require(band.soberRange())

        #expect(abs(sober.lowerBound.timeIntervalSince(t0) / 60 - 355) < 2)
        #expect(abs(sober.upperBound.timeIntervalSince(t0) / 60 - 522) < 2)
    }

    @Test("The upper branch never drops below the lower one")
    func bandIsOrdered() {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let violations = band.samples.filter { $0.high < $0.low - 1e-9 }
        #expect(violations.isEmpty)
    }

    @Test("The centre line stays inside the band throughout")
    func centerInsideBand() {
        let band = engine.simulateBand(profile: reference, drinks: series)
        let outside = band.samples.filter { $0.mid < $0.low - 1e-6 || $0.mid > $0.high + 1e-6 }
        #expect(outside.isEmpty)
    }

    @Test("Empty input gives an empty band")
    func emptyInput() {
        let band = engine.simulateBand(profile: reference, drinks: [])
        #expect(band.isEmpty)
        #expect(band.peakRange == nil)
        #expect(band.soberRange() == nil)
    }

    @Test("Greater uncertainty widens the band")
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

@Suite("Three-state limit crossing")
struct LimitOutcomeTests {

    /// The reference peak band is 0.510–0.625 g/L.
    @Test("below / uncertain / above depending on where the limit sits")
    func outcomeBoundaries() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 12, stomach: .light)
        let consumed = Array(series.prefix(2))

        func outcome(limit: Double) -> LimitOutcome {
            engine.projectBand(profile: reference, consumed: consumed, candidate: candidate, limit: limit).outcome
        }

        #expect(outcome(limit: 0.40) == .above)      // crosses even with fast elimination
        #expect(outcome(limit: 0.60) == .uncertain)  // only with slow elimination
        #expect(outcome(limit: 0.90) == .below)      // not at all
    }

    @Test("The outcome is monotonic in the limit")
    func monotonicInLimit() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 12, stomach: .light)
        let consumed = Array(series.prefix(2))

        var seenBelow = false
        for step in stride(from: 0.2, through: 1.2, by: 0.05) {
            let outcome = engine.projectBand(
                profile: reference, consumed: consumed, candidate: candidate, limit: step
            ).outcome
            if outcome == .below { seenBelow = true }
            // once "below", a higher limit can never be stricter
            if seenBelow { #expect(outcome == .below) }
        }
    }

    @Test("The convenience flags are consistent")
    func helperFlags() {
        #expect(LimitOutcome.below.exceedsPossible == false)
        #expect(LimitOutcome.uncertain.exceedsPossible == true)
        #expect(LimitOutcome.above.exceedsPossible == true)

        #expect(LimitOutcome.below.exceedsCertain == false)
        #expect(LimitOutcome.uncertain.exceedsCertain == false)
        #expect(LimitOutcome.above.exceedsCertain == true)
    }
}

@Suite("Banded projection")
struct BandedProjectionTests {

    @Test("The projected peak range sits above the current one")
    func projectionRaisesPeak() {
        let consumed = Array(series.prefix(2))
        let candidate = Drink(consumedAt: minute(90), volumeMl: 500, abvPercent: 5)
        let p = engine.projectBand(profile: reference, consumed: consumed, candidate: candidate, limit: 1.2)

        #expect(p.peakRange.lowerBound > p.currentRange.lowerBound)
        #expect(p.timeToPeak > 0)
        #expect(p.soberRange != nil)
    }

    @Test("A larger drink shifts the band up and clears later")
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

    @Test("With no history the current range is zero")
    func firstDrinkOfTheSession() {
        let candidate = Drink(consumedAt: t0, volumeMl: 500, abvPercent: 5)
        let p = engine.projectBand(profile: reference, consumed: [], candidate: candidate, limit: 0.8)

        #expect(p.currentRange.lowerBound == 0)
        #expect(p.currentRange.upperBound == 0)
        #expect(p.peakRange.lowerBound > 0)
    }
}
