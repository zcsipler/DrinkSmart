import Testing
import Foundation
@testable import BACKit

private let t0 = Date(timeIntervalSince1970: 0)

private func minute(_ m: Double) -> Date { t0.addingTimeInterval(m * 60) }

private func drink(
    _ kind: String,
    at m: Double,
    over minutes: Double,
    ml: Double = 500,
    abv: Double = 5
) -> Drink {
    Drink(
        consumedAt: minute(m),
        volumeMl: ml,
        abvPercent: abv,
        stomach: .light,
        drinkingMinutes: minutes,
        name: kind
    )
}

@Suite("Pour shortening")
struct PourShorteningTests {

    @Test("A second beer cuts the first one short at that moment")
    func sameKindInterrupts() throws {
        let first = drink("beer", at: 0, over: 30)
        let second = drink("beer", at: 20, over: 30)

        let cut = try #require([first].pourCut(by: second))
        #expect(cut.drinkID == first.id)
        #expect(cut.drinkingMinutes == 20)
    }

    @Test("A shot in the middle of a beer leaves the beer alone")
    func otherKindIsNotEvidence() {
        let beer = drink("beer", at: 0, over: 30)
        let shot = drink("spirit", at: 20, over: 0, ml: 40, abv: 40)

        #expect([beer].pourCut(by: shot) == nil)
        #expect([beer].shorteningPour(for: shot) == [beer])
    }

    @Test("A beer that was already finished is not touched")
    func finishedPourIsNotInterrupted() {
        let first = drink("beer", at: 0, over: 30)
        let second = drink("beer", at: 45, over: 30)

        #expect([first].pourCut(by: second) == nil)
    }

    @Test("A drink downed in one go has no pour to cut")
    func instantDrinkIsNotInterrupted() {
        let first = drink("spirit", at: 0, over: 0, ml: 40, abv: 40)
        let second = drink("spirit", at: 5, over: 0, ml: 40, abv: 40)

        #expect([first].pourCut(by: second) == nil)
    }

    @Test("Only the most recent open beer is cut")
    func onlyTheLatestMatch() throws {
        // The first was already cut short by the second; it is the second that
        // the third interrupts.
        let first = drink("beer", at: 0, over: 20)
        let second = drink("beer", at: 20, over: 30)
        let third = drink("beer", at: 35, over: 30)

        let cut = try #require([first, second].pourCut(by: third))
        #expect(cut.drinkID == second.id)
        #expect(cut.drinkingMinutes == 15)
    }

    @Test("Applying the cut twice changes nothing the second time")
    func idempotent() {
        // The projection reruns on every keystroke, so a second pass must not
        // walk the duration further down.
        let first = drink("beer", at: 0, over: 30)
        let second = drink("beer", at: 20, over: 30)

        let once = [first].shorteningPour(for: second)
        let twice = once.shorteningPour(for: second)

        #expect(once.first?.drinkingMinutes == 20)
        #expect(twice == once)
    }

    @Test("A backdated drink does not reach forwards in time")
    func earlierCandidateLeavesLaterDrinksAlone() {
        let later = drink("beer", at: 60, over: 30)
        let backdated = drink("beer", at: 30, over: 30)

        #expect([later].pourCut(by: backdated) == nil)
    }

    @Test("A drink does not cut itself short when it is being edited")
    func editingTheSameDrink() {
        // The edit sheet projects the corrected drink against a list that may
        // still contain the original row.
        let original = drink("beer", at: 0, over: 30)
        var edited = original
        edited.consumedAt = minute(10)

        #expect([original].pourCut(by: edited) == nil)
    }

    @Test("Cutting the pour short steepens the rise it was flattening")
    func theCutIsVisibleInTheCurve() throws {
        let profile = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
        let engine = BACEngine()

        let first = drink("beer", at: 0, over: 60)
        let second = drink("beer", at: 20, over: 60)

        let asLogged = engine.simulate(profile: profile, drinks: [first, second])
        let shortened = engine.simulate(
            profile: profile,
            drinks: [first, second].shorteningPour(for: second)
        )

        // Same alcohol either way, delivered sooner.
        let loggedRate = asLogged.samples.map(\.rate).max() ?? 0
        let shortenedRate = shortened.samples.map(\.rate).max() ?? 0
        #expect(shortenedRate > loggedRate)
    }
}
