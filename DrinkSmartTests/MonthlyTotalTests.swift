import Foundation
import SwiftData
import Testing
import BACKit
@testable import DrinkSmart

/// Months known only as a total, folded into days, periods and windows.
///
/// The failures these guard are the ones 5.7 is about: a total that turns
/// into invented dry days, a total that vanishes because one evening in the
/// month was logged, a week that claims a whole month's drinking as its own.
@Suite("Monthly totals in history")
struct MonthlyTotalTests {

    let calendar = HistoryAggregateTests.calendar
    let fixture = HistoryAggregateTests()

    func date(_ y: Int, _ m: Int, _ d: Int, _ h: Int = 12) -> Date { fixture.date(y, m, d, h) }

    func month(_ y: Int, _ m: Int, grams: Double) -> KnownMonth {
        KnownMonth(year: y, month: m, gramsEthanol: grams)
    }

    var now: Date { date(2026, 9, 14, 20) }

    /// Records began 2026-09-10; June and July 2026 are known by total,
    /// August is not known at all.
    var days: [DayBucket] {
        HistoryAggregate.days(
            from: [fixture.occasion(at: date(2026, 9, 12, 21), units: 4)],
            knownMonths: [month(2026, 6, grams: 300), month(2026, 7, grams: 150)],
            trackingStartedAt: date(2026, 9, 10),
            now: now, calendar: calendar
        )
    }

    // MARK: Days

    @Test("The list reaches back to the first month known by total")
    func listStartsAtFirstKnownMonth() {
        let days = days
        #expect(days.first?.day == DrinkingDay.containing(date(2026, 6, 1, 12), calendar: calendar))
        #expect(days.last?.day == DrinkingDay.containing(now, calendar: calendar))
    }

    @Test("Days in a summarized month are unknown, not dry, and carry the month")
    func summarizedDaysStayUnknown() {
        let june = days.filter { calendar.component(.month, from: $0.day.calendarDate) == 6 }
        #expect(june.count == 30)
        #expect(june.allSatisfy { $0.state == .unknown })
        #expect(june.allSatisfy { $0.summarizedMonth?.month == month(2026, 6, grams: 300) })
        #expect(june.allSatisfy { $0.totalUnits == 0 })
    }

    @Test("A month with no total between a summarized month and records is plain unknown")
    func gapMonthIsUnknownWithoutAMonth() {
        let august = days.filter { calendar.component(.month, from: $0.day.calendarDate) == 8 }
        #expect(august.count == 31)
        #expect(august.allSatisfy { $0.state == .unknown && $0.summarizedMonth == nil })
    }

    @Test("Records still begin where they began: September before the 10th is unknown")
    func recordsBeganIsUnchanged() {
        let september = days.filter { calendar.component(.month, from: $0.day.calendarDate) == 9 }
        #expect(september.prefix(9).allSatisfy { $0.state == .unknown })
        #expect(september[9].state == .dry)
    }

    @Test("A zero month makes its days dry, and they still carry the month")
    func zeroMonthIsDry() {
        let days = HistoryAggregate.days(
            from: [],
            knownMonths: [month(2026, 8, grams: 0)],
            trackingStartedAt: date(2026, 9, 10),
            now: now, calendar: calendar
        )
        let august = days.filter { calendar.component(.month, from: $0.day.calendarDate) == 8 }
        #expect(august.count == 31)
        #expect(august.allSatisfy { $0.state == .dry })
        #expect(august.allSatisfy { $0.summarizedMonth?.isZero == true })

        let periods = HistoryAggregate.periods(days, by: .month, calendar: calendar)
        #expect(periods.first?.dryDays == 31)
        #expect(periods.first?.totalUnits == 0)
    }

    @Test("A total for a month entirely inside the recorded span is ignored")
    func totalInsideRecordsIsIgnored() {
        let days = HistoryAggregate.days(
            from: [],
            knownMonths: [month(2026, 9, grams: 500)],
            trackingStartedAt: date(2026, 8, 1),
            now: now, calendar: calendar
        )
        #expect(days.allSatisfy { $0.summarizedMonth == nil })
        #expect(days.totalUnits == 0)
    }

    // MARK: Sums

    @Test("A month period carries its total as units")
    func monthPeriodHasTheTotal() {
        let months = HistoryAggregate.periods(days, by: .month, calendar: calendar)
        let june = months.first { calendar.component(.month, from: $0.interval.start) == 6 }
        #expect(june?.totalUnits == 30)
        #expect(june?.drinkCount == 0)
        #expect(june?.drinkingDays == 0)
        #expect(june?.dryDays == 0)
        #expect(june?.unknownDays == 30)
        #expect(june?.unitsPerRecordedDay.map { abs($0 - 1) < 1e-9 } == true)
    }

    @Test("A year period sums totals and occasions")
    func yearSumsBoth() {
        let years = HistoryAggregate.periods(days, by: .year, calendar: calendar)
        #expect(years.count == 1)
        #expect(years[0].totalUnits == 30 + 15 + 4)
        #expect(years[0].summarizedMonths.count == 2)
    }

    @Test("A week that straddles a summarized month does not claim the month")
    func weekDoesNotClaimTheMonth() {
        let weeks = HistoryAggregate.periods(days, by: .week, calendar: calendar)
        let lastJuneWeek = weeks.first {
            $0.interval.contains(date(2026, 6, 30)) && $0.interval.contains(date(2026, 7, 1))
        }
        #expect(lastJuneWeek != nil)
        #expect(lastJuneWeek?.totalUnits == 0)
        #expect(lastJuneWeek?.summarizedMonths.count == 2)
        #expect(lastJuneWeek?.days.wholeSummarizedMonths.isEmpty == true)
    }

    @Test("Records beginning mid-month leave the total's remainder to the unknown days")
    func straddlingMonthKeepsTheRemainder() {
        let days = HistoryAggregate.days(
            from: [fixture.occasion(at: date(2026, 9, 12, 21), units: 4)],
            knownMonths: [month(2026, 9, grams: 100)],
            trackingStartedAt: date(2026, 9, 10),
            now: now, calendar: calendar
        )
        let september = days.filter { calendar.component(.month, from: $0.day.calendarDate) == 9 }
        let summarized = september.first?.summarizedMonth
        #expect(summarized?.unknownDays == 9)
        #expect(summarized?.remainderUnits == 6)
        #expect(september.prefix(9).allSatisfy { $0.summarizedMonth != nil })
        #expect(september.dropFirst(9).allSatisfy { $0.summarizedMonth == nil })

        // Whole in this list — all nine unknown days are here — so the month
        // is the total, not the total plus the evening.
        #expect(september.totalUnits == 10)
    }

    @Test("A total smaller than what was logged is not believed below zero")
    func staleTotalIsClampedToTheOccasions() {
        let days = HistoryAggregate.days(
            from: [fixture.occasion(at: date(2026, 9, 12, 21), units: 4)],
            knownMonths: [month(2026, 9, grams: 10)],
            trackingStartedAt: date(2026, 9, 10),
            now: now, calendar: calendar
        )
        #expect(days.first?.summarizedMonth?.remainderUnits == 0)
        #expect(days.totalUnits == 4)
    }

    // MARK: Colour scale basis

    @Test("A bar's known days are its recorded days plus the days a whole total covers")
    func knownDaysBehindABar() {
        let year = HistoryWindow.make(range: .year, offset: 0, days: days, now: now, calendar: calendar)
        func bar(_ month: Int) -> HistoryBar? {
            year.bars.first { calendar.component(.month, from: $0.interval.start) == month }
        }
        #expect(bar(6)?.knownDays == 30)     // summarized whole
        #expect(bar(8)?.knownDays == 1)      // nothing known: the floor, never zero
        #expect(bar(9)?.knownDays == 5)      // Sep 10–14 recorded, 1–9 unknown

        let week = HistoryWindow.make(range: .week, offset: 0, days: days, now: now, calendar: calendar)
        #expect(week.bars.allSatisfy { $0.knownDays == 1 })
    }

    @Test("A month recorded partway keeps the total's days and the recorded days apart")
    func knownDaysOfAStraddlingMonth() {
        let days = HistoryAggregate.days(
            from: [fixture.occasion(at: date(2026, 9, 12, 21), units: 4)],
            knownMonths: [month(2026, 9, grams: 100)],
            trackingStartedAt: date(2026, 9, 10), now: now, calendar: calendar
        )
        let year = HistoryWindow.make(range: .year, offset: 0, days: days, now: now, calendar: calendar)
        let september = year.bars.first { calendar.component(.month, from: $0.interval.start) == 9 }
        // Nine days from the total, five recorded — the amount (10 units) is
        // read over fourteen days, not over five and not over thirty.
        #expect(september?.knownDays == 14)
        #expect(september?.totalUnits == 10)
    }

    // MARK: Windows

    @Test("In the year view a summarized month is a bar with its total")
    func yearBarIsSummarized() {
        let year = HistoryWindow.make(range: .year, offset: 0, days: days, now: now, calendar: calendar)
        let june = year.bars.first { calendar.component(.month, from: $0.interval.start) == 6 }
        #expect(june?.state == .summarized)
        #expect(june?.totalUnits == 30)
        #expect(june?.peakRange == nil)
        #expect(june?.summarizedMonth?.month == month(2026, 6, grams: 300))

        let august = year.bars.first { calendar.component(.month, from: $0.interval.start) == 8 }
        #expect(august?.state == .unknown)

        let may = year.bars.first { calendar.component(.month, from: $0.interval.start) == 5 }
        #expect(may?.state == .unknown)
    }

    @Test("The month window of a summarized month has the total and no bar heights")
    func monthWindowOfSummarizedMonth() {
        let offset = HistoryWindow.offset(containing: date(2026, 7, 15), range: .month, now: now, calendar: calendar)
        let july = HistoryWindow.make(range: .month, offset: offset, days: days, now: now, calendar: calendar)
        #expect(july.bars.count == 31)
        #expect(july.bars.allSatisfy { $0.state == .summarized && $0.totalUnits == 0 })
        #expect(july.totalUnits == 15)

        let figures = july.figures
        #expect(figures.totalUnits == 15)
        #expect(figures.summarizedMonths == 1)
        #expect(figures.coarseDays == 31)
        #expect(figures.unrecordedDays == 0)
        #expect(figures.recordedDays == 0)
    }

    @Test("The year figures tell summarized days apart from days before records")
    func yearFiguresSeparateTheTwoKindsOfUnknown() {
        let year = HistoryWindow.make(range: .year, offset: 0, days: days, now: now, calendar: calendar)
        let figures = year.figures
        #expect(figures.summarizedMonths == 2)
        #expect(figures.coarseDays == 30 + 31)
        // January–May are before the list, August and Sep 1–9 in it: unknown
        // without a month either way.
        #expect(figures.unrecordedDays == figures.unknownDays - 61)
        #expect(figures.totalUnits == 49)
    }

    @Test("The change against a summarized previous window is computed")
    func changeAgainstSummarizedMonth() {
        let offset = HistoryWindow.offset(containing: date(2026, 7, 15), range: .month, now: now, calendar: calendar)
        let july = HistoryWindow.make(range: .month, offset: offset, days: days, now: now, calendar: calendar)
        #expect(july.previousUnits == 30)
        #expect(july.unitsChange.map { abs($0 + 0.5) < 1e-9 } == true)
    }

    @Test("Paging reaches back to the first summarized month")
    func oldestOffsetCoversTotals() {
        let oldest = HistoryWindow.oldestOffset(for: .month, days: days, now: now, calendar: calendar)
        #expect(oldest == 3)
    }

    // MARK: Import

    @Test("An archive's monthly totals are merged by person, year and month")
    @MainActor
    func importMergesMonths() throws {
        let context = try makeContext()
        let owner = Person(
            name: "", isOwner: true, profile: .test, frequency: .regular, limit: 0.8
        )
        context.insert(owner)
        context.insert(MonthlyTotal(personID: owner.id, year: 2026, month: 6, gramsEthanol: 999))
        try context.save()

        let archive = DataArchive(
            people: [],
            sessions: [],
            monthlyTotals: [
                ArchivedMonthlyTotal(personID: owner.id, year: 2026, month: 6, gramsEthanol: 300),
                ArchivedMonthlyTotal(personID: owner.id, year: 2026, month: 7, gramsEthanol: 150),
                ArchivedMonthlyTotal(personID: owner.id, year: 2026, month: 7, gramsEthanol: 151),
                ArchivedMonthlyTotal(personID: owner.id, year: 2026, month: 13, gramsEthanol: 1),
            ]
        )
        let plan = ArchiveImport.plan(archive, in: context)
        #expect(plan.monthsToAdd == 1)
        #expect(!plan.changesNothing)

        let outcome = ArchiveImport.apply(plan, in: context)
        #expect(outcome.monthsAdded == 1)

        let stored = try context.fetch(FetchDescriptor<MonthlyTotal>())
            .sorted { ($0.year, $0.month) < ($1.year, $1.month) }
        #expect(stored.count == 2)
        #expect(stored[0].gramsEthanol == 999)   // the existing June was left alone
        #expect(stored[1].month == 7 && stored[1].gramsEthanol == 150)

        // Idempotent: the same file again changes nothing.
        #expect(ArchiveImport.plan(archive, in: context).changesNothing)
    }

    @Test("An archive without the key decodes, and exports carry the key")
    func archiveRoundTrip() throws {
        let legacy = Data(#"{"schemaVersion":1,"exportedAt":"2026-09-26T13:35:47Z","people":[],"sessions":[]}"#.utf8)
        let decoded = try DataArchive.decoded(from: legacy)
        #expect(decoded.monthlyTotals == nil)

        let archive = DataArchive(
            people: [], sessions: [],
            monthlyTotals: [ArchivedMonthlyTotal(personID: UUID(), year: 2020, month: 1, gramsEthanol: 1701)]
        )
        let again = try DataArchive.decoded(from: try archive.encoded())
        #expect(again.monthlyTotals == archive.monthlyTotals)
    }
}
