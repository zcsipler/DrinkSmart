import Testing
import Foundation
@testable import BACKit

/// Expected values come from `Reference/bac_model.py`.
private let reference = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
private let t0 = Date(timeIntervalSince1970: 0)
private let engine = BACEngine()

private func minute(_ m: Double) -> Date { t0.addingTimeInterval(m * 60) }

private func beer(at m: Double, over minutes: Double) -> Drink {
    Drink(
        consumedAt: minute(m),
        volumeMl: 500,
        abvPercent: 5,
        stomach: .light,
        drinkingMinutes: minutes
    )
}

@Suite("Drinking pace")
struct DrinkingPaceTests {

    @Test("Zero duration is bit-identical to the old instantaneous dose")
    func zeroDurationMatchesBolus() throws {
        // The default must not move a single stored curve.
        let implicit = Drink(consumedAt: t0, volumeMl: 500, abvPercent: 5, stomach: .light)
        let explicit = beer(at: 0, over: 0)

        #expect(implicit.drinkingMinutes == 0)

        let a = try #require(engine.simulate(profile: reference, drinks: [implicit]).peak)
        let b = try #require(engine.simulate(profile: reference, drinks: [explicit]).peak)

        #expect(a.bac == b.bac)
        #expect(abs(a.bac - 0.181692) < 1e-4)
    }

    @Test("A single beer matches the reference at every pace")
    func singleDrinkMatchesReference() throws {
        let expected: [(Double, Double, Double)] = [
            //  minutes,  peak,      peak time
            (0,   0.181692, 43),
            (15,  0.175823, 51),
            (30,  0.166818, 60),
            (60,  0.142792, 80),
            (120, 0.087770, 127),
        ]

        for (minutes, peakBAC, peakMinute) in expected {
            let curve = engine.simulate(profile: reference, drinks: [beer(at: 0, over: minutes)])
            let peak = try #require(curve.peak)
            #expect(abs(peak.bac - peakBAC) < 1e-4)
            #expect(abs(peak.date.timeIntervalSince(t0) / 60 - peakMinute) < 1.5)
        }
    }

    @Test("Sipping lowers the peak and pushes it later")
    func slowerIsLowerAndLater() {
        var lastPeak = Double.infinity
        var lastTime = -Double.infinity

        for minutes in [0.0, 15, 30, 60, 120] {
            let peak = engine.simulate(profile: reference, drinks: [beer(at: 0, over: minutes)]).peak!
            #expect(peak.bac < lastPeak)
            #expect(peak.date.timeIntervalSince(t0) > lastTime)
            lastPeak = peak.bac
            lastTime = peak.date.timeIntervalSince(t0)
        }
    }

    @Test("Mass conservation holds regardless of pace")
    func massConservation() {
        for minutes in [0.0, 30, 120] {
            let drink = beer(at: 0, over: minutes)
            let curve = engine.simulate(profile: reference, drinks: [drink])

            let input = drink.absorbedGrams / reference.distributionVolume
            let eliminated = curve.samples
                .filter { $0.bac > 0 }
                .reduce(0.0) {
                    $0 + ($1.bac / (Physiology.michaelisConstant + $1.bac)) * (reference.beta / 60)
                }

            #expect(abs(input - eliminated) / input < 0.01)
        }
    }

    /// The reason the feature exists. Over a whole evening pace barely touches
    /// the peak — but it halves how steeply the level climbs, and that is what
    /// memory impairment tracks.
    @Test("Across an evening pace moves the rise rate, not the peak")
    func paceMovesRiseRateNotPeak() throws {
        func evening(pace: Double) -> (peak: Double, rise: Double) {
            let drinks = (0..<4).map { beer(at: Double($0) * 60, over: pace) }
            let curve = engine.simulate(profile: reference, drinks: drinks)
            return (curve.peak!.bac, curve.steepestRise!.rate)
        }

        let thrown = evening(pace: 0)
        let sipped = evening(pace: 30)

        // Python reference: 0.725 vs 0.710 g/L, and 0.81 vs 0.36 g/L/h.
        #expect(abs(thrown.peak - 0.725) < 0.01)
        #expect(abs(sipped.peak - 0.710) < 0.01)
        #expect(abs(thrown.rise - 0.81) < 0.03)
        #expect(abs(sipped.rise - 0.36) < 0.03)

        let peakDrop = (thrown.peak - sipped.peak) / thrown.peak
        let riseDrop = (thrown.rise - sipped.rise) / thrown.rise
        #expect(peakDrop < 0.05)    // the peak barely moves
        #expect(riseDrop > 0.40)    // the climb is roughly halved
    }

    @Test("A drink still being poured keeps the simulation running")
    func longDrinkIsNotCutShort() throws {
        // A three-hour drink must not trip the early exit: at the start the
        // level is near zero while alcohol is still arriving.
        let curve = engine.simulate(profile: reference, drinks: [beer(at: 0, over: 180)])
        let peak = try #require(curve.peak)

        // Python reference: 0.044 g/L at 181 minutes — essentially the moment
        // the last sip lands, because elimination keeps pace with such a slow
        // intake.
        #expect(abs(peak.bac - 0.044) < 0.005)
        #expect(abs(peak.date.timeIntervalSince(t0) / 60 - 181) < 3)
        #expect(curve.samples.last!.date.timeIntervalSince(t0) / 60 > 180)
    }

    @Test("Negative durations are clamped rather than inverting the flow")
    func negativeDurationIsClamped() {
        let drink = Drink(
            consumedAt: t0, volumeMl: 500, abvPercent: 5,
            stomach: .light, drinkingMinutes: -30
        )
        #expect(drink.drinkingMinutes == 0)
        #expect(drink.finishedAt == t0)
    }

    @Test("Drinks written before the duration existed decode as instantaneous")
    func decodesLegacyDrink() throws {
        let legacy = """
        {"id":"\(UUID().uuidString)","consumedAt":0,"volumeMl":500,
         "abvPercent":5,"stomach":"light"}
        """.data(using: .utf8)!

        let drink = try JSONDecoder().decode(Drink.self, from: legacy)
        #expect(drink.drinkingMinutes == 0)
        #expect(drink.volumeMl == 500)
    }
}
