import Foundation

/// The three windows the History screen can show. Not `HistoryPeriod`: a
/// period is how days are *grouped*, a range is how much of the calendar is
/// *on screen* — and the week on screen is the last seven drinking days, not
/// a calendar week, so that the free window (seven days, today included) is
/// exactly the first page of the week view and nothing behind it.
enum HistoryRange: String, CaseIterable, Identifiable, Sendable {
    case week, month, year

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        }
    }

    /// What one bar stands for.
    var barPeriod: HistoryPeriod {
        switch self {
        case .week, .month: .day
        case .year: .month
        }
    }
}

/// One bar of the history chart: a day in the week and month views, a month
/// in the year view.
struct HistoryBar: Identifiable, Hashable, Sendable {

    enum State: Hashable, Sendable {
        case drank, dry, unknown
        /// After today. Drawn as empty space, never as a dry day.
        case future
    }

    let interval: DateInterval
    let state: State
    let days: [DayBucket]

    var id: Date { interval.start }

    var totalUnits: Double { days.reduce(0) { $0 + $1.totalUnits } }
    var drinkCount: Int { days.reduce(0) { $0 + $1.drinkCount } }

    var peakRange: ClosedRange<Double>? {
        days.compactMap(\.peakRange).max { $0.upperBound < $1.upperBound }
    }

    var peakIsComplete: Bool { days.allSatisfy(\.peakIsComplete) }

    /// The limit to colour this bar's peak against: the strictest in force.
    var limit: Double? { days.compactMap(\.limit).min() }

    var recordedDays: Int { days.filter { $0.state != .unknown }.count }
}

/// What the History screen shows for one range at one offset from today.
///
/// Built from the continuous day list `HistoryAggregate.days` produces, so a
/// window can be assembled without touching the store — and tested the same
/// way. Offset 0 is the window that ends today; 1 is the one before it.
struct HistoryWindow: Hashable, Sendable {
    let range: HistoryRange
    let offset: Int
    let interval: DateInterval
    let bars: [HistoryBar]

    /// Total units of the window before this one, for the change figure. Nil
    /// when nothing about that window was recorded.
    let previousUnits: Double?

    // MARK: Figures

    var days: [DayBucket] { bars.flatMap(\.days) }

    var totalUnits: Double { bars.reduce(0) { $0 + $1.totalUnits } }
    var drinkCount: Int { bars.reduce(0) { $0 + $1.drinkCount } }

    var drinkingDays: Int { days.filter { $0.state == .drank }.count }
    var dryDays: Int { days.filter { $0.state == .dry }.count }
    var unknownDays: Int { days.filter { $0.state == .unknown }.count }
    var recordedDays: Int { days.count - unknownDays }

    var peakRange: ClosedRange<Double>? {
        bars.compactMap(\.peakRange).max { $0.upperBound < $1.upperBound }
    }

    var peakIsComplete: Bool { bars.allSatisfy(\.peakIsComplete) }

    /// The strictest limit in force during the window, for colouring the peak.
    var limit: Double? { bars.compactMap(\.limit).min() }

    /// Change in units against the previous window, as a fraction. Nil when
    /// the previous window has nothing to compare against — a first month is
    /// not "up infinitely".
    var unitsChange: Double? {
        guard let previousUnits, previousUnits > 0 else { return nil }
        return (totalUnits - previousUnits) / previousUnits
    }

    /// Whether every recorded day on screen is inside the free window. True
    /// only for the week view at offset 0, by construction — but derived from
    /// the days rather than asserted, so there is one rule, not two.
    func isWithinFreeWindow(at now: Date, calendar: Calendar = .current) -> Bool {
        days.allSatisfy { FeatureFlags.isWithinFreeWindow($0.day, at: now, calendar: calendar) }
    }

    // MARK: Building

    /// - Parameter days: the full continuous day list, oldest first.
    static func make(
        range: HistoryRange,
        offset: Int,
        days: [DayBucket],
        now: Date = .now,
        calendar: Calendar = .current
    ) -> HistoryWindow {
        let interval = Self.interval(for: range, offset: offset, now: now, calendar: calendar)
        let previous = Self.interval(for: range, offset: offset + 1, now: now, calendar: calendar)
        let today = DrinkingDay.containing(now, calendar: calendar)
        let byDay = Dictionary(uniqueKeysWithValues: days.map { ($0.day, $0) })

        func bucket(_ barInterval: DateInterval) -> HistoryBar {
            var found: [DayBucket] = []
            var day = DrinkingDay.containing(
                barInterval.start.addingTimeInterval(Double(DrinkingDay.boundaryHour) * 3600),
                calendar: calendar
            )
            var sawFuture = false
            while day.calendarDate < barInterval.end {
                if let bucket = byDay[day] {
                    found.append(bucket)
                } else if day.start > today.start {
                    sawFuture = true
                } else {
                    // Before the first recorded day: not looking yet.
                    found.append(DayBucket(day: day, state: .unknown, occasions: []))
                }
                day = day.offset(by: 1, calendar: calendar)
            }

            let state: HistoryBar.State = if found.contains(where: { $0.state == .drank }) {
                .drank
            } else if found.contains(where: { $0.state == .dry }) {
                .dry
            } else if found.isEmpty && sawFuture {
                .future
            } else {
                .unknown
            }
            return HistoryBar(interval: barInterval, state: state, days: found)
        }

        let bars = Self.barIntervals(in: interval, range: range, calendar: calendar).map(bucket)

        // Not `DateInterval.contains`: that is closed at the end, and the end
        // of the previous window is the first day of this one.
        let previousDays = days.filter {
            $0.day.calendarDate >= previous.start && $0.day.calendarDate < previous.end
        }
        let previousRecorded = previousDays.contains { $0.state != .unknown }
        let previousUnits = previousRecorded ? previousDays.reduce(0) { $0 + $1.totalUnits } : nil

        return HistoryWindow(
            range: range, offset: offset, interval: interval, bars: bars, previousUnits: previousUnits
        )
    }

    /// The calendar span on screen. Week: seven drinking days ending today
    /// (offset 0) or seven days earlier per step. Month and year: the calendar
    /// unit containing today, stepped back whole units.
    static func interval(
        for range: HistoryRange,
        offset: Int,
        now: Date = .now,
        calendar: Calendar = .current
    ) -> DateInterval {
        let today = DrinkingDay.containing(now, calendar: calendar)
        switch range {
        case .week:
            let last = today.offset(by: -7 * offset, calendar: calendar)
            let first = last.offset(by: -6, calendar: calendar)
            return DateInterval(start: first.calendarDate, end: last.end)
        case .month, .year:
            let component: Calendar.Component = range == .month ? .month : .year
            let anchor = calendar.date(byAdding: component, value: -offset, to: today.calendarDate)
                ?? today.calendarDate
            return calendar.dateInterval(of: component, for: anchor)
                ?? DateInterval(start: today.start, end: today.end)
        }
    }

    /// The offset whose window contains `date` — how the header's date picker
    /// turns a chosen day into a page. Never negative: a future date lands on
    /// the current window.
    static func offset(
        containing date: Date,
        range: HistoryRange,
        now: Date = .now,
        calendar: Calendar = .current
    ) -> Int {
        let today = DrinkingDay.containing(now, calendar: calendar)
        let target = DrinkingDay.containing(date, calendar: calendar)
        switch range {
        case .week:
            return max(0, target.daysAgo(from: now, calendar: calendar) / 7)
        case .month, .year:
            // Whole calendar units apart, not elapsed time: Aug 15 is one
            // month-page before Sep 14 even though thirty days have not passed.
            let component: Calendar.Component = range == .month ? .month : .year
            let from = calendar.dateInterval(of: component, for: target.calendarDate)?.start ?? target.calendarDate
            let to = calendar.dateInterval(of: component, for: today.calendarDate)?.start ?? today.calendarDate
            let distance = calendar.dateComponents([component], from: from, to: to)
            let steps = range == .month ? distance.month : distance.year
            return max(0, steps ?? 0)
        }
    }

    /// The earliest offset with anything recorded — how far back the user can
    /// page. Zero when there is no history at all.
    static func oldestOffset(
        for range: HistoryRange,
        days: [DayBucket],
        now: Date = .now,
        calendar: Calendar = .current
    ) -> Int {
        guard let first = days.first?.day.calendarDate else { return 0 }
        var offset = 0
        while interval(for: range, offset: offset, now: now, calendar: calendar).start > first {
            offset += 1
            if offset > 1200 { break }   // a century of months; something is wrong
        }
        return offset
    }

    // MARK: Helpers

    private static func barIntervals(
        in interval: DateInterval,
        range: HistoryRange,
        calendar: Calendar
    ) -> [DateInterval] {
        var result: [DateInterval] = []
        var cursor = interval.start
        while cursor < interval.end {
            let next = shift(cursor, by: 1, range: range, calendar: calendar)
            result.append(DateInterval(start: cursor, end: min(next, interval.end)))
            cursor = next
        }
        return result
    }

    /// Moves a bar boundary by whole bars.
    private static func shift(_ date: Date, by bars: Int, range: HistoryRange, calendar: Calendar) -> Date {
        let component: Calendar.Component = range.barPeriod == .day ? .day : .month
        return calendar.date(byAdding: component, value: bars, to: date) ?? date
    }
}
