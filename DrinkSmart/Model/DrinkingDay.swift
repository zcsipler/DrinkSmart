import Foundation

/// A day as a drinker experiences it, not as the calendar draws it.
///
/// The boundary sits at 05:00 rather than midnight, so an evening that starts
/// at 22:00 and ends at 03:00 belongs to the day it *started*. With a midnight
/// boundary the same evening would be cut in two: the peak on one day, the
/// tail on the next, and neither half telling the truth.
///
/// Five in the morning is a compromise, not a discovery. It is late enough to
/// catch almost every night out and early enough that a genuine early riser is
/// not filed under yesterday. If it ever needs to be configurable, this is the
/// single place that changes.
struct DrinkingDay: Hashable, Identifiable {

    static let boundaryHour = 5

    /// 05:00 on the day this window belongs to.
    let start: Date

    var id: Date { start }

    var end: Date { start.addingTimeInterval(24 * 3600) }

    var range: Range<Date> { start..<end }

    func contains(_ date: Date) -> Bool {
        date >= start && date < end
    }

    // MARK: Construction

    static func containing(_ date: Date, calendar: Calendar = .current) -> DrinkingDay {
        let boundaryToday = calendar.date(
            bySettingHour: boundaryHour, minute: 0, second: 0, of: date
        ) ?? calendar.startOfDay(for: date)

        // Before 05:00 the evening still belongs to the previous day.
        let start = date < boundaryToday
            ? calendar.date(byAdding: .day, value: -1, to: boundaryToday) ?? boundaryToday
            : boundaryToday

        return DrinkingDay(start: start)
    }

    func offset(by days: Int, calendar: Calendar = .current) -> DrinkingDay {
        DrinkingDay(start: calendar.date(byAdding: .day, value: days, to: start) ?? start)
    }

    // MARK: Presentation

    func isCurrent(at date: Date = .now, calendar: Calendar = .current) -> Bool {
        self == DrinkingDay.containing(date, calendar: calendar)
    }

    /// How many drinking days back this is from the current one.
    func daysAgo(from date: Date = .now, calendar: Calendar = .current) -> Int {
        let current = DrinkingDay.containing(date, calendar: calendar)
        return calendar.dateComponents([.day], from: start, to: current.start).day ?? 0
    }

    /// The date the window is filed under — its own calendar day, which for a
    /// window starting at 05:00 is simply the start date.
    var calendarDate: Date { start }
}
