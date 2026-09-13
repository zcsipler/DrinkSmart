import Testing
import Foundation
@testable import BACKit

/// Expected values come from the `Reference/bac_model.py` implementation.
/// If Swift and Python disagree, the algorithm drifted — not the test.
private let reference = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
private let t0 = Date(timeIntervalSince1970: 0)
private let engine = BACEngine()

private func minute(_ m: Double) -> Date { t0.addingTimeInterval(m * 60) }

// MARK: - Anthropometry

@Suite("Body profile")
struct BodyProfileTests {

    @Test("Watson total body water matches the reference")
    func totalBodyWater() {
        #expect(abs(reference.totalBodyWater - 45.344400) < 1e-4)
        #expect(abs(reference.distributionVolume - 53.346353) < 1e-4)
    }

    @Test("Derived Widmark factor lands in the classic range")
    func widmarkInExpectedRange() {
        #expect(abs(reference.widmarkFactor - 0.666829) < 1e-4)

        let female = BodyProfile(sex: .female, age: 35, heightCm: 167, weightKg: 62)
        // Classic literature values: men around 0.68–0.70, women 0.55–0.60.
        #expect((0.62...0.72).contains(reference.widmarkFactor))
        #expect((0.53...0.63).contains(female.widmarkFactor))
    }

    @Test("A woman reaches a higher level from the same dose")
    func sexDifference() {
        let female = BodyProfile(sex: .female, age: 35, heightCm: 167, weightKg: 62)
        let drink = Drink(consumedAt: t0, volumeMl: 100, abvPercent: 40, stomach: .empty)

        let m = engine.simulate(profile: reference, drinks: [drink]).peak!.bac
        let f = engine.simulate(profile: female, drinks: [drink]).peak!.bac
        #expect(f > m)
    }
}

// MARK: - Drink

@Suite("Drink")
struct DrinkTests {

    @Test("Ethanol content and standard units")
    func ethanolContent() {
        let beer = Drink(consumedAt: t0, volumeMl: 500, abvPercent: 5)
        #expect(abs(beer.gramsEthanol - 19.725) < 1e-6)
        #expect(abs(beer.standardUnits - 1.9725) < 1e-6)
    }

    @Test("A full stomach reduces bioavailability")
    func bioavailability() {
        let volume = 40.0, abv = 40.0
        let empty = Drink(consumedAt: t0, volumeMl: volume, abvPercent: abv, stomach: .empty)
        let full = Drink(consumedAt: t0, volumeMl: volume, abvPercent: abv, stomach: .full)
        #expect(empty.gramsEthanol == full.gramsEthanol)
        #expect(empty.absorbedGrams > full.absorbedGrams)
    }
}

// MARK: - Simulation

@Suite("BAC curve")
struct BACEngineTests {

    @Test("Single spirit on an empty stomach matches the Python reference")
    func singleSpiritMatchesReference() throws {
        let drink = Drink(consumedAt: t0, volumeMl: 40, abvPercent: 40, stomach: .empty)
        let curve = engine.simulate(profile: reference, drinks: [drink])

        let peak = try #require(curve.peak)
        #expect(abs(peak.bac - 0.155350) < 1e-4)
        #expect(abs(peak.date.timeIntervalSince(t0) / 60 - 23) < 1.5)

        #expect(abs(curve.value(at: minute(15)) - 0.145404) < 1e-4)
        #expect(abs(curve.value(at: minute(30)) - 0.151209) < 1e-4)
        #expect(abs(curve.value(at: minute(60)) - 0.097231) < 1e-4)
        #expect(abs(curve.value(at: minute(120)) - 0.005477) < 1e-4)

        let sober = try #require(curve.soberDate())
        #expect(abs(sober.timeIntervalSince(t0) / 60 - 114) < 2)
    }

    @Test("A series of three drinks matches the Python reference")
    func drinkSeriesMatchesReference() throws {
        let drinks = [
            Drink(consumedAt: minute(0), volumeMl: 500, abvPercent: 5, stomach: .full),
            Drink(consumedAt: minute(45), volumeMl: 500, abvPercent: 5, stomach: .light),
            Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 12, stomach: .light),
        ]
        let curve = engine.simulate(profile: reference, drinks: drinks)

        let peak = try #require(curve.peak)
        #expect(abs(peak.bac - 0.565699) < 1e-4)
        #expect(abs(peak.date.timeIntervalSince(t0) / 60 - 138) < 1.5)

        #expect(abs(curve.value(at: minute(60)) - 0.243508) < 1e-4)
        #expect(abs(curve.value(at: minute(180)) - 0.515553) < 1e-4)
        #expect(abs(curve.value(at: minute(240)) - 0.385413) < 1e-4)
    }

    @Test("Stomach contents monotonically lower and delay the peak")
    func stomachStateMonotonicity() {
        var peaks: [(Double, Double)] = []
        for stomach in [StomachState.empty, .light, .full] {
            let drink = Drink(consumedAt: t0, volumeMl: 500, abvPercent: 5, stomach: stomach)
            let peak = engine.simulate(profile: reference, drinks: [drink]).peak!
            peaks.append((peak.bac, peak.date.timeIntervalSince(t0) / 60))
        }
        #expect(peaks[0].0 > peaks[1].0 && peaks[1].0 > peaks[2].0)   // progressively lower
        #expect(peaks[0].1 < peaks[1].1 && peaks[1].1 < peaks[2].1)   // progressively later
    }

    @Test("The descending limb follows the beta parameter")
    func eliminationSlope() {
        let drink = Drink(consumedAt: t0, volumeMl: 200, abvPercent: 40, stomach: .empty)
        let curve = engine.simulate(profile: reference, drinks: [drink])
        let slope = curve.value(at: minute(180)) - curve.value(at: minute(240))
        #expect(abs(slope - reference.beta) < 0.01)
    }

    @Test("Higher beta clears faster")
    func fasterMetabolism() {
        var fast = reference
        fast.beta = 0.22
        let drink = Drink(consumedAt: t0, volumeMl: 200, abvPercent: 40, stomach: .empty)

        let slow = engine.simulate(profile: reference, drinks: [drink]).soberDate()!
        let quick = engine.simulate(profile: fast, drinks: [drink]).soberDate()!
        #expect(quick < slow)
    }

    @Test("Mass conservation: what is eliminated equals what went in")
    func massConservation() {
        let drink = Drink(consumedAt: t0, volumeMl: 40, abvPercent: 40, stomach: .empty)
        let curve = engine.simulate(profile: reference, drinks: [drink])

        let input = drink.absorbedGrams / reference.distributionVolume
        let eliminated = curve.samples
            .filter { $0.bac > 0 }
            .reduce(0.0) { $0 + ($1.bac / (Physiology.michaelisConstant + $1.bac)) * (reference.beta / 60) }

        #expect(abs(input - eliminated) / input < 0.01)
    }

    @Test("The curve never goes negative")
    func neverNegative() {
        let drink = Drink(consumedAt: t0, volumeMl: 1, abvPercent: 5)
        let curve = engine.simulate(profile: reference, drinks: [drink])
        #expect(curve.samples.allSatisfy { $0.bac >= 0 })
    }

    @Test("Empty input gives an empty curve")
    func emptyInput() {
        let curve = engine.simulate(profile: reference, drinks: [])
        #expect(curve.samples.isEmpty)
        #expect(curve.peak == nil)
    }

    @Test("The order drinks are passed in does not matter")
    func orderIndependence() {
        let a = Drink(consumedAt: minute(0), volumeMl: 500, abvPercent: 5)
        let b = Drink(consumedAt: minute(60), volumeMl: 40, abvPercent: 40)
        let forward = engine.simulate(profile: reference, drinks: [a, b], from: t0).peak!.bac
        let reversed = engine.simulate(profile: reference, drinks: [b, a], from: t0).peak!.bac
        #expect(abs(forward - reversed) < 1e-9)
    }
}

// MARK: - Projection

@Suite("Next drink projection")
struct ProjectionTests {

    private var consumed: [Drink] {
        [
            Drink(consumedAt: minute(0), volumeMl: 500, abvPercent: 5, stomach: .full),
            Drink(consumedAt: minute(45), volumeMl: 500, abvPercent: 5, stomach: .light),
        ]
    }

    @Test("The projected peak sits above the current level")
    func projectionRaisesPeak() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 500, abvPercent: 5)
        let p = engine.project(profile: reference, consumed: consumed, candidate: candidate, limit: 1.2)
        #expect(p.projectedPeak > p.currentBAC)
        #expect(p.increment > 0)
        #expect(p.timeToPeak > 0)
    }

    @Test("A larger drink gives a higher peak and a later sober time")
    func largerDrinkLargerPeak() {
        let small = Drink(consumedAt: minute(90), volumeMl: 40, abvPercent: 40)
        let large = Drink(consumedAt: minute(90), volumeMl: 120, abvPercent: 40)

        let ps = engine.project(profile: reference, consumed: consumed, candidate: small, limit: 1.2)
        let pl = engine.project(profile: reference, consumed: consumed, candidate: large, limit: 1.2)

        #expect(pl.projectedPeak > ps.projectedPeak)
        #expect(pl.soberAt! > ps.soberAt!)
    }

    @Test("A low limit reports the crossing and when it happens")
    func limitDetection() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 200, abvPercent: 40, stomach: .empty)
        let p = engine.project(profile: reference, consumed: consumed, candidate: candidate, limit: 0.5)

        #expect(p.exceedsLimit)
        #expect(p.limitCrossedAt != nil)
        #expect(p.timeAboveLimit > 0)
    }

    @Test("A high limit reports no crossing")
    func withinLimit() {
        let candidate = Drink(consumedAt: minute(90), volumeMl: 40, abvPercent: 40)
        let p = engine.project(profile: reference, consumed: consumed, candidate: candidate, limit: 3.0)
        #expect(!p.exceedsLimit)
        #expect(p.limitCrossedAt == nil)
        #expect(p.timeAboveLimit == 0)
    }

    @Test("The largest permitted drink really stays under the limit")
    func largestDrinkWithinLimit() throws {
        let template = Drink(consumedAt: minute(90), volumeMl: 500, abvPercent: 5)
        let limit = 0.8

        // The Python reference gives roughly 884 mL of 5 % beer.
        let maxVolume = try #require(
            engine.largestDrinkWithinLimit(
                profile: reference, consumed: consumed, template: template, limit: limit
            )
        )
        #expect(abs(maxVolume - 884) < 5)

        var atLimit = template
        atLimit.volumeMl = maxVolume
        #expect(!engine.project(profile: reference, consumed: consumed, candidate: atLimit, limit: limit).exceedsLimit)

        var overLimit = template
        overLimit.volumeMl = maxVolume + 50
        #expect(engine.project(profile: reference, consumed: consumed, candidate: overLimit, limit: limit).exceedsLimit)
    }

    @Test("No drink fits when the current level is already over the limit")
    func alreadyOverLimit() {
        let heavy = consumed + [Drink(consumedAt: minute(60), volumeMl: 300, abvPercent: 40, stomach: .empty)]
        let template = Drink(consumedAt: minute(120), volumeMl: 500, abvPercent: 5)
        #expect(engine.largestDrinkWithinLimit(
            profile: reference, consumed: heavy, template: template, limit: 0.3
        ) == nil)
    }

    @Test("Drinking faster gives a steeper rise for the same amount")
    func riseRateReflectsPacing() throws {
        let fast = (0..<4).map { Drink(consumedAt: minute(Double($0) * 10), volumeMl: 40, abvPercent: 40, stomach: .empty) }
        let slow = (0..<4).map { Drink(consumedAt: minute(Double($0) * 60), volumeMl: 40, abvPercent: 40, stomach: .empty) }

        let fastRate = try #require(engine.simulate(profile: reference, drinks: fast).steepestRise).rate
        let slowRate = try #require(engine.simulate(profile: reference, drinks: slow).steepestRise).rate

        // Python reference: 1.951 fast, 1.349 slow, in g/L/h.
        #expect(fastRate > slowRate)
        #expect(abs(fastRate - 1.951) < 0.02)
        #expect(abs(slowRate - 1.349) < 0.02)
    }
}
