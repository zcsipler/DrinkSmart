import Foundation
import Testing
import BACKit
@testable import DrinkSmart

/// The window on screen: which days it covers, what the bars hold, how the
/// figures above it are derived.
@Suite("History window")
struct HistoryWindowTests {

    let calendar = HistoryAggregateTests.calendar
    let fixture = HistoryAggregateTests()

    func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date { fixture.date(y, m, d, h) }

    /// Six weeks of days ending Monday 2026-09-14 evening, with three evenings
    /// out: 8 units on Aug 15, 2 on Sep 8, 4 on Sep 12.
    var days: [DayBucket] {
        HistoryAggregate.days(
            from: [
                fixture.occasion(at: date(2026, 8, 15, 20), units: 8, peak: 0.9...1.0),
                fixture.occasion(at: date(2026, 9, 8, 20), units: 2, peak: 0.3...0.35),
                fixture.occasion(at: date(2026, 9, 12, 21), units: 4, peak: 0.6...0.7),
            ],
            trackingStartedAt: date(2026, 8, 3),
            now: now, calendar: calendar
        )
    }

    var now: Date { date(2026, 9, 14, 20) }

    // MARK: Intervals

    @Test("The week window is the last seven drinking days, today included")
    func weekIsRollingSevenDays() {
        let window = HistoryWindow.make(range: .week, offset: 0, days: days, now: now, calendar: calendar)

        #expect(window.bars.count == 7)
        #expect(window.bars.first?.days.first?.day == DrinkingDay.containing(date(2026, 9, 8), calendar: calendar))
        #expect(window.bars.last?.days.first?.day == DrinkingDay.containing(now, calendar: calendar))
        #expect(window.bars.allSatisfy { $0.days.count == 1 })
    }

    @Test("Paging the week back moves by seven days without overlap")
    func weekPagesBySeven() {
        let current = HistoryWindow.interval(for: .week, offset: 0, now: now, calendar: calendar)
        let previous = HistoryWindow.interval(for: .week, offset: 1, now: now, calendar: calendar)

        #expect(previous.end == current.start)
        #expect(calendar.dateComponents([.day], from: previous.start, to: current.start).day == 7)
    }

    @Test("The month window is the calendar month, one bar per day")
    func monthIsCalendarMonth() {
        let window = HistoryWindow.make(range: .month, offset: 0, days: days, now: now, calendar: calendar)

        #expect(calendar.component(.day, from: window.interval.start) == 1)
        #expect(calendar.component(.month, from: window.interval.start) == 9)
        #expect(window.bars.count == 30)
    }

    @Test("Days after today are future, not dry")
    func futureDaysAreFuture() {
        let window = HistoryWindow.make(range: .month, offset: 0, days: days, now: now, calendar: calendar)

        let states = window.bars.map(\.state)
        #expect(states[13] == .dry)          // Sep 14, today
        #expect(states[14] == .future)       // Sep 15
        #expect(states.suffix(16).allSatisfy { $0 == .future })
    }

    @Test("Days before records began are unknown and stay out of the figures")
    func earlyDaysAreUnknown() {
        let window = HistoryWindow.make(range: .month, offset: 1, days: days, now: now, calendar: calendar)

        #expect(window.bars.count == 31)
        #expect(window.bars[0].state == .unknown)     // Aug 1
        #expect(window.bars[1].state == .unknown)     // Aug 2
        #expect(window.bars[2].state == .dry)         // Aug 3, tracking started
        #expect(window.unknownDays == 2)
        #expect(window.recordedDays == 29)
        #expect(window.drinkingDays == 1)
        #expect(window.dryDays == 28)
        #expect(window.totalUnits == 8)
    }

    @Test("The year window has twelve monthly bars")
    func yearHasTwelveMonths() {
        let window = HistoryWindow.make(range: .year, offset: 0, days: days, now: now, calendar: calendar)

        #expect(window.bars.count == 12)
        #expect(window.bars[7].state == .drank)       // August
        #expect(window.bars[7].totalUnits == 8)
        #expect(window.bars[8].state == .drank)       // September, so far
        #expect(window.bars[8].totalUnits == 6)
        #expect(window.bars[9].state == .future)      // October
        #expect(window.bars[0].state == .unknown)     // January, before records
    }

    // MARK: Figures

    @Test("Peak of the window is the highest peak, coloured against that day's limit")
    func peakAndLimit() {
        let window = HistoryWindow.make(range: .month, offset: 1, days: days, now: now, calendar: calendar)

        #expect(window.peakRange == 0.9...1.0)
        #expect(window.limit == 0.8)
        #expect(window.peakIsComplete)
    }

    @Test("Change compares against the previous window of the same range")
    func changeAgainstPreviousWindow() throws {
        // September so far: 6 units. August: 8. Down a quarter.
        let window = HistoryWindow.make(range: .month, offset: 0, days: days, now: now, calendar: calendar)
        let change = try #require(window.unitsChange)

        #expect(abs(change - (-0.25)) < 1e-9)
    }

    @Test("The first recorded window has no change figure")
    func noChangeForFirstWindow() {
        let window = HistoryWindow.make(range: .month, offset: 1, days: days, now: now, calendar: calendar)

        #expect(window.previousUnits == nil)
        #expect(window.unitsChange == nil)
    }

    // MARK: Free window

    @Test("Only the current week is inside the free window")
    func freeWindowIsThisWeek() {
        #expect(HistoryWindow.make(range: .week, offset: 0, days: days, now: now, calendar: calendar)
            .isWithinFreeWindow(at: now, calendar: calendar))
        #expect(!HistoryWindow.make(range: .week, offset: 1, days: days, now: now, calendar: calendar)
            .isWithinFreeWindow(at: now, calendar: calendar))
        #expect(!HistoryWindow.make(range: .month, offset: 0, days: days, now: now, calendar: calendar)
            .isWithinFreeWindow(at: now, calendar: calendar))
    }

    // MARK: Jumping

    @Test("A chosen date maps to the page that contains it")
    func offsetForDate() {
        // Today is Mon Sep 14. Sep 8 is in this week's page; Sep 7 in the one before.
        #expect(HistoryWindow.offset(containing: date(2026, 9, 8), range: .week, now: now, calendar: calendar) == 0)
        #expect(HistoryWindow.offset(containing: date(2026, 9, 7), range: .week, now: now, calendar: calendar) == 1)
        #expect(HistoryWindow.offset(containing: date(2026, 8, 15), range: .month, now: now, calendar: calendar) == 1)
        #expect(HistoryWindow.offset(containing: date(2023, 9, 1), range: .month, now: now, calendar: calendar) == 36)
        #expect(HistoryWindow.offset(containing: date(2023, 9, 1), range: .year, now: now, calendar: calendar) == 3)
        // Never into the future.
        #expect(HistoryWindow.offset(containing: date(2027, 1, 1), range: .month, now: now, calendar: calendar) == 0)
    }

    @Test("Jumping to a date and reading the window back round-trips")
    func offsetRoundTrips() {
        let target = date(2023, 9, 1)
        for range in HistoryRange.allCases {
            let offset = HistoryWindow.offset(containing: target, range: range, now: now, calendar: calendar)
            let interval = HistoryWindow.interval(for: range, offset: offset, now: now, calendar: calendar)
            #expect(interval.start <= target && target < interval.end)
        }
    }

    // MARK: Paging limits

    @Test("The oldest offset reaches the first recorded day and no further")
    func oldestOffset() {
        // Records start Aug 3; today is Sep 14. Six weeks back covers it.
        #expect(HistoryWindow.oldestOffset(for: .week, days: days, now: now, calendar: calendar) == 6)
        #expect(HistoryWindow.oldestOffset(for: .month, days: days, now: now, calendar: calendar) == 1)
        #expect(HistoryWindow.oldestOffset(for: .year, days: days, now: now, calendar: calendar) == 0)
        #expect(HistoryWindow.oldestOffset(for: .week, days: [], now: now, calendar: calendar) == 0)
    }
}
