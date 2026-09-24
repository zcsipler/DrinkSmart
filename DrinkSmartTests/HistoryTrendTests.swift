import Foundation
import Testing
import BACKit
@testable import DrinkSmart

/// The two trend curves: what they run over, and how they fade.
@Suite("History trend")
struct HistoryTrendTests {

    let calendar = HistoryAggregateTests.calendar
    let fixture = HistoryAggregateTests()

    func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date { fixture.date(y, m, d, h) }

    var now: Date { date(2026, 9, 14, 20) }

    /// Records from Sep 1; evenings out on Sep 2 (4 units, peak 0.6), Sep 5
    /// (2 units, peak 0.3, cache stale so no peak) and Sep 12 (6 units, 0.9).
    var days: [DayBucket] {
        HistoryAggregate.days(
            from: [
                fixture.occasion(at: date(2026, 9, 2, 20), units: 4, peak: 0.55...0.65),
                fixture.occasion(at: date(2026, 9, 5, 20), units: 2, peak: nil),
                fixture.occasion(at: date(2026, 9, 12, 21), units: 6, peak: 0.85...0.95),
            ],
            trackingStartedAt: date(2026, 9, 1),
            now: now, calendar: calendar
        )
    }

    // MARK: EMA

    @Test("A half-life halves the weight of the past every N samples")
    func emaHalfLife() {
        // A single spike, then silence: after one half-life it has faded to half.
        var values = [Double](repeating: 0, count: 8)
        values[0] = 1
        let smoothed = HistoryTrend.ema(values, halfLife: 7)

        #expect(smoothed[0] == 1)
        #expect(abs(smoothed[7] - 0.5) < 1e-9)
        #expect(smoothed.count == values.count)
        #expect(HistoryTrend.ema([], halfLife: 7).isEmpty)
    }

    @Test("A constant input is its own average")
    func emaConstant() {
        let smoothed = HistoryTrend.ema([Double](repeating: 3, count: 20), halfLife: 30)
        #expect(smoothed.allSatisfy { abs($0 - 3) < 1e-9 })
    }

    // MARK: Curves

    @Test("The amount curve has a point for every recorded day, dry days included")
    func amountRunsOverEveryDay() {
        let trend = HistoryTrend.make(days: days, halfLife: 7)

        #expect(trend.amount.count == 14)
        #expect(trend.amount.first?.day == DrinkingDay.containing(date(2026, 9, 1), calendar: calendar))
        #expect(trend.amount.first?.value == 0)
        // Sinks on a dry day rather than dropping to zero.
        let sep2 = trend.amount[1].value
        let sep3 = trend.amount[2].value
        #expect(sep2 > 0 && sep3 > 0 && sep3 < sep2)
    }

    @Test("The peak curve steps over drinking days with a known peak only")
    func peakRunsOverDrinkingDays() {
        let trend = HistoryTrend.make(days: days, halfLife: 7)

        #expect(trend.peak.map(\.day) == [
            DrinkingDay.containing(date(2026, 9, 2), calendar: calendar),
            DrinkingDay.containing(date(2026, 9, 12), calendar: calendar),
        ])
        #expect(trend.peaks.count == 2)
        #expect(abs(trend.peaks[0].value - 0.6) < 1e-9)
        #expect(abs(trend.peaks[1].value - 0.9) < 1e-9)
        #expect(abs(trend.peak[0].value - 0.6) < 1e-9)
        // Ten sober days between the two evenings do not dilute the step.
        let alpha = 1 - pow(0.5, 1.0 / 7)
        #expect(abs(trend.peak[1].value - (alpha * 0.9 + (1 - alpha) * 0.6)) < 1e-9)
    }

    @Test("Days before records began are not on either curve")
    func unknownDaysSkipped() {
        let early = HistoryAggregate.days(
            from: [fixture.occasion(at: date(2026, 9, 12, 21), units: 6, peak: 0.85...0.95)],
            trackingStartedAt: date(2026, 9, 10),
            now: now, calendar: calendar
        )
        let trend = HistoryTrend.make(days: early, halfLife: 7)

        #expect(trend.amount.first?.day == DrinkingDay.containing(date(2026, 9, 10), calendar: calendar))
        #expect(trend.amount.count == 5)
    }

    @Test("Smoothing follows the zoom in three bands")
    func halfLifeBands() {
        #expect(HistoryTrend.halfLife(forVisibleDays: 14) == 7)
        #expect(HistoryTrend.halfLife(forVisibleDays: 89) == 7)
        #expect(HistoryTrend.halfLife(forVisibleDays: 90) == 30)
        #expect(HistoryTrend.halfLife(forVisibleDays: 729) == 30)
        #expect(HistoryTrend.halfLife(forVisibleDays: 730) == 90)
    }
}
