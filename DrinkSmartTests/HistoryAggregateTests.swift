import Foundation
import Testing
import BACKit
@testable import DrinkSmart

/// Days and periods folded from sessions.
///
/// Everything here is arithmetic on values, but the failures it guards are
/// the quiet kind: a night out counted on the wrong day, a week that starts on
/// Sunday in one place and Monday in another, a "dry" day that was really a
/// day before records began.
@Suite("History aggregate")
struct HistoryAggregateTests {

    /// A fixed calendar, so the week boundary does not depend on the machine
    /// running the tests. Monday-first, Budapest.
    static let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "Europe/Budapest")!
        c.firstWeekday = 2
        c.locale = Locale(identifier: "hu_HU")
        return c
    }()

    var calendar: Calendar { Self.calendar }

    /// Local wall-clock time in the fixed calendar.
    func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12, _ min: Int = 0) -> Date {
        calendar.date(from: DateComponents(year: y, month: m, day: d, hour: h, minute: min))!
    }

    func occasion(
        at start: Date,
        units: Double = 2,
        drinks: Int = 2,
        peak: ClosedRange<Double>? = 0.4...0.5,
        limit: Double = 0.8
    ) -> HistoryOccasion {
        HistoryOccasion(
            id: UUID(), startedAt: start, totalUnits: units, drinkCount: drinks,
            peakRange: peak, limit: limit
        )
    }

    // MARK: Days

    @Test("Every day from tracking start to today is present, dry ones included")
    func daysAreContinuous() {
        let start = date(2026, 9, 10)
        let now = date(2026, 9, 14, 20)
        let days = HistoryAggregate.days(
            from: [occasion(at: date(2026, 9, 12, 21))],
            trackingStartedAt: start, now: now, calendar: calendar
        )

        #expect(days.count == 5)
        #expect(days.map(\.state) == [.dry, .dry, .drank, .dry, .dry])
        #expect(days.first?.day == DrinkingDay.containing(start, calendar: calendar))
        #expect(days.last?.day == DrinkingDay.containing(now, calendar: calendar))
    }

    @Test("A session that ran past midnight belongs to the day it started")
    func lateNightStaysOnItsDay() {
        // Started at 23:30 on the 12th; a drink at 02:00 on the 13th is still
        // the same session. The 13th must read as dry.
        let days = HistoryAggregate.days(
            from: [occasion(at: date(2026, 9, 12, 23, 30))],
            trackingStartedAt: date(2026, 9, 12),
            now: date(2026, 9, 13, 20), calendar: calendar
        )

        #expect(days.count == 2)
        #expect(days[0].state == .drank)
        #expect(days[1].state == .dry)
    }

    @Test("Before 05:00 the day has not turned yet")
    func earlyMorningIsStillYesterday() {
        // Someone logging at 03:00 on the 13th is on the 12th's drinking day.
        let days = HistoryAggregate.days(
            from: [occasion(at: date(2026, 9, 13, 3))],
            trackingStartedAt: date(2026, 9, 12),
            now: date(2026, 9, 13, 20), calendar: calendar
        )

        #expect(days.count == 2)
        #expect(days[0].state == .drank)
        #expect(days[1].state == .dry)
    }

    @Test("Days before tracking began are unknown, not dry")
    func unknownIsNotDry() {
        // A session imported from before records officially began pulls the
        // range back; the gap between it and the tracking start is unknown.
        let days = HistoryAggregate.days(
            from: [occasion(at: date(2026, 9, 1, 20))],
            trackingStartedAt: date(2026, 9, 4),
            now: date(2026, 9, 5, 12), calendar: calendar
        )

        #expect(days.map(\.state) == [.drank, .unknown, .unknown, .dry, .dry])
    }

    @Test("Two sessions on one day add up")
    func twoSessionsOneDay() throws {
        let days = HistoryAggregate.days(
            from: [
                occasion(at: date(2026, 9, 12, 13), units: 1, drinks: 1, peak: 0.2...0.25),
                occasion(at: date(2026, 9, 12, 20), units: 3, drinks: 3, peak: 0.5...0.6),
            ],
            trackingStartedAt: date(2026, 9, 12), now: date(2026, 9, 12, 22), calendar: calendar
        )

        let bucket = try #require(days.first)
        #expect(bucket.totalUnits == 4)
        #expect(bucket.drinkCount == 4)
        #expect(bucket.peakRange == 0.5...0.6)
        #expect(bucket.peakIsComplete)
    }

    @Test("A stale cache leaves the peak missing but keeps the quantity")
    func stalePeakDoesNotHideQuantity() throws {
        let days = HistoryAggregate.days(
            from: [
                occasion(at: date(2026, 9, 12, 13), units: 1, peak: 0.2...0.25),
                occasion(at: date(2026, 9, 12, 20), units: 3, peak: nil),
            ],
            trackingStartedAt: date(2026, 9, 12), now: date(2026, 9, 12, 22), calendar: calendar
        )

        let bucket = try #require(days.first)
        #expect(bucket.totalUnits == 4)
        #expect(bucket.peakRange == 0.2...0.25)
        #expect(!bucket.peakIsComplete)
    }

    @Test("Nothing before tracking and no sessions gives today alone")
    func freshInstall() {
        let now = date(2026, 9, 14, 20)
        let days = HistoryAggregate.days(
            from: [], trackingStartedAt: now.addingTimeInterval(-60), now: now, calendar: calendar
        )

        #expect(days.count == 1)
        #expect(days.first?.state == .dry)
    }

    // MARK: Periods

    @Test("Weeks start on Monday in a Monday-first calendar")
    func weeksFollowTheCalendar() {
        // 2026-09-14 is a Monday. Sunday the 13th must be in the previous week.
        let days = HistoryAggregate.days(
            from: [], trackingStartedAt: date(2026, 9, 13),
            now: date(2026, 9, 14, 20), calendar: calendar
        )
        let weeks = HistoryAggregate.periods(days, by: .week, calendar: calendar)

        #expect(weeks.count == 2)
        #expect(weeks[0].days.count == 1)
        #expect(weeks[1].days.count == 1)
        #expect(calendar.component(.weekday, from: weeks[1].interval.start) == 2)
    }

    @Test("A month sums its days and counts dry ones")
    func monthTotals() {
        let sessions = [
            occasion(at: date(2026, 8, 3, 20), units: 2),
            occasion(at: date(2026, 8, 20, 20), units: 5),
            occasion(at: date(2026, 9, 2, 20), units: 1),
        ]
        let days = HistoryAggregate.days(
            from: sessions, trackingStartedAt: date(2026, 8, 1),
            now: date(2026, 9, 5, 12), calendar: calendar
        )
        let months = HistoryAggregate.periods(days, by: .month, calendar: calendar)

        #expect(months.count == 2)
        let august = months[0]
        #expect(august.days.count == 31)
        #expect(august.totalUnits == 7)
        #expect(august.drinkingDays == 2)
        #expect(august.dryDays == 29)
        #expect(august.unknownDays == 0)
        #expect(august.unitsPerRecordedDay.map { abs($0 - 7.0 / 31) < 1e-9 } == true)

        let september = months[1]
        #expect(september.days.count == 5)
        #expect(september.totalUnits == 1)
    }

    @Test("The day period is one bucket per day")
    func dayPeriodIsIdentity() {
        let days = HistoryAggregate.days(
            from: [], trackingStartedAt: date(2026, 9, 10),
            now: date(2026, 9, 14, 20), calendar: calendar
        )
        let periods = HistoryAggregate.periods(days, by: .day, calendar: calendar)

        #expect(periods.count == days.count)
        #expect(periods.map(\.interval.start) == days.map(\.day.start))
    }

    @Test("Unknown days do not dilute the average")
    func unknownDaysAreNotInTheDenominator() throws {
        let days = HistoryAggregate.days(
            from: [occasion(at: date(2026, 9, 1, 20), units: 4)],
            trackingStartedAt: date(2026, 9, 4),
            now: date(2026, 9, 5, 12), calendar: calendar
        )
        let month = try #require(HistoryAggregate.periods(days, by: .month, calendar: calendar).first)

        // Five days in the range, two of them unknown; three recorded.
        #expect(month.recordedDays == 3)
        #expect(month.unitsPerRecordedDay.map { abs($0 - 4.0 / 3) < 1e-9 } == true)
    }

    @Test("Change against an empty previous period is nil, not infinite")
    func changeAgainstNothing() {
        let days = HistoryAggregate.days(
            from: [occasion(at: date(2026, 9, 2, 20), units: 3)],
            trackingStartedAt: date(2026, 8, 25),
            now: date(2026, 9, 5, 12), calendar: calendar
        )
        let months = HistoryAggregate.periods(days, by: .month, calendar: calendar)

        #expect(months.count == 2)
        #expect(months[1].unitsChange(from: months[0]) == nil)
    }

    @Test("Change is a fraction of the previous total")
    func changeIsRelative() throws {
        let days = HistoryAggregate.days(
            from: [
                occasion(at: date(2026, 8, 10, 20), units: 4),
                occasion(at: date(2026, 9, 2, 20), units: 5),
            ],
            trackingStartedAt: date(2026, 8, 1),
            now: date(2026, 9, 5, 12), calendar: calendar
        )
        let months = HistoryAggregate.periods(days, by: .month, calendar: calendar)
        let change = try #require(months[1].unitsChange(from: months[0]))

        #expect(abs(change - 0.25) < 1e-9)
    }
}

/// The free window, on its own.
@Suite("Free history window")
struct FreeHistoryWindowTests {

    let calendar = HistoryAggregateTests.calendar

    func day(_ daysAgo: Int, from now: Date) -> DrinkingDay {
        DrinkingDay.containing(now, calendar: calendar).offset(by: -daysAgo, calendar: calendar)
    }

    @Test("Today and the six days before it are free")
    func sevenDaysIncludingToday() {
        let now = HistoryAggregateTests().date(2026, 9, 14, 20)

        for ago in 0..<FeatureFlags.freeHistoryWindowDays {
            #expect(FeatureFlags.isWithinFreeWindow(day(ago, from: now), at: now, calendar: calendar))
        }
        #expect(!FeatureFlags.isWithinFreeWindow(
            day(FeatureFlags.freeHistoryWindowDays, from: now), at: now, calendar: calendar
        ))
    }

    @Test("The window follows the drinking day, not the calendar day")
    func windowUsesDrinkingDays() {
        // 03:00 on the 14th is still the 13th's drinking day. Seven drinking
        // days back from there is the 6th, which must be outside.
        let now = HistoryAggregateTests().date(2026, 9, 14, 3)
        let seventh = DrinkingDay.containing(
            HistoryAggregateTests().date(2026, 9, 7, 20), calendar: calendar
        )
        let eighth = DrinkingDay.containing(
            HistoryAggregateTests().date(2026, 9, 6, 20), calendar: calendar
        )

        #expect(FeatureFlags.isWithinFreeWindow(seventh, at: now, calendar: calendar))
        #expect(!FeatureFlags.isWithinFreeWindow(eighth, at: now, calendar: calendar))
    }
}
