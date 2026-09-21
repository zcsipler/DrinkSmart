import Foundation
import BACKit

/// The numbers behind the week / month / year views, computed from sessions.
///
/// Nothing here is stored. A year of history is a few hundred sessions, each
/// already carrying its cached summary (`SessionSummary`), and folding those
/// into days and periods in memory is cheaper than a second persisted entity
/// would be to keep CloudKit-compatible, exported and migrated.
///
/// Two rules shape every type in this file:
///
/// - **Quantity never waits for the engine.** Units and drink counts are sums
///   over the stored drinks and need no simulation. Peak level does, and it
///   comes from the cache — so when the cache is stale (an engine version
///   bump), the peak is simply missing rather than computed on the spot.
///   `HistoryOccasion.peakRange` is optional for exactly this reason, and every
///   bucket says whether its peak is complete.
/// - **"Did not drink" and "do not know" are different (5.7).** A day before
///   the person's `trackingStartedAt` is `.unknown`; an empty day after it is
///   `.dry`. Dry days are counted, unknown days are not.
enum HistoryAggregate {

    /// The days from the earlier of `trackingStartedAt` and the first occasion
    /// up to and including the day containing `now`, oldest first.
    ///
    /// Continuous on purpose: a dry day is a row too. A chart that only knew
    /// the days you drank could not show the ones you did not.
    static func days(
        from occasions: [HistoryOccasion],
        trackingStartedAt: Date,
        now: Date = .now,
        calendar: Calendar = .current
    ) -> [DayBucket] {
        let today = DrinkingDay.containing(now, calendar: calendar)
        let trackingDay = DrinkingDay.containing(trackingStartedAt, calendar: calendar)

        // A session with no drinks is not an evening out. One can exist —
        // a quick add undone, the last drink deleted from an open session —
        // and it must not turn a dry day into a drinking day with a
        // zero-height bar that answers a tap with "0 g".
        var byDay: [DrinkingDay: [HistoryOccasion]] = [:]
        for occasion in occasions where occasion.drinkCount > 0 && occasion.startedAt <= today.end {
            byDay[DrinkingDay.containing(occasion.startedAt, calendar: calendar), default: []]
                .append(occasion)
        }

        let firstDay = ([trackingDay] + byDay.keys).min { $0.start < $1.start } ?? today
        guard firstDay.start <= today.start else { return [] }

        var result: [DayBucket] = []
        var day = firstDay
        while day.start <= today.start {
            let occasions = (byDay[day] ?? []).sorted { $0.startedAt < $1.startedAt }
            let state: DayBucket.State = if !occasions.isEmpty {
                .drank
            } else if day.start < trackingDay.start {
                .unknown
            } else {
                .dry
            }
            result.append(DayBucket(day: day, state: state, occasions: occasions))
            day = day.offset(by: 1, calendar: calendar)
        }
        return result
    }

    /// Folds days into calendar periods, oldest first.
    ///
    /// The day view is the days themselves — `.day` returns one period per
    /// day, so a caller can treat all four ranges the same way.
    static func periods(
        _ days: [DayBucket],
        by period: HistoryPeriod,
        calendar: Calendar = .current
    ) -> [PeriodBucket] {
        var ordered: [DateInterval] = []
        var grouped: [DateInterval: [DayBucket]] = [:]

        for day in days {
            let interval = period.interval(containing: day, calendar: calendar)
            if grouped[interval] == nil { ordered.append(interval) }
            grouped[interval, default: []].append(day)
        }

        return ordered.map { PeriodBucket(period: period, interval: $0, days: grouped[$0] ?? []) }
    }
}

/// The four ranges the History screen offers.
enum HistoryPeriod: String, CaseIterable, Identifiable, Sendable {
    case day, week, month, year

    var id: String { rawValue }

    /// The calendar span a drinking day is filed under. A day is filed by its
    /// own date — the 05:00 start — so an evening that ran past midnight stays
    /// in the week and month it began in, the same way it stays in its day.
    func interval(containing day: DayBucket, calendar: Calendar) -> DateInterval {
        switch self {
        case .day:
            return DateInterval(start: day.day.start, end: day.day.end)
        case .week, .month, .year:
            let component: Calendar.Component = switch self {
            case .week: .weekOfYear
            case .month: .month
            default: .year
            }
            return calendar.dateInterval(of: component, for: day.day.calendarDate)
                ?? DateInterval(start: day.day.start, end: day.day.end)
        }
    }
}

/// One session, reduced to what history needs — a value, so the aggregate
/// can be built and tested without a model context.
struct HistoryOccasion: Hashable, Identifiable, Sendable {
    let id: UUID
    let startedAt: Date
    let totalUnits: Double
    let drinkCount: Int

    /// Nil when the stored summary is missing or predates the current engine.
    /// Never computed here: that is the store's job, in the background.
    let peakRange: ClosedRange<Double>?

    /// The limit as it stood for this session (5.5, 5.14). A bar drawn for
    /// this occasion is coloured against *this* number, not today's.
    let limit: Double
}

extension DrinkingSession {
    /// The session as history sees it. Units and count are summed from the
    /// drinks when the cache is stale, because they cost nothing; the peak is
    /// taken only from a valid cache.
    var historyOccasion: HistoryOccasion {
        let cached = summary
        return HistoryOccasion(
            id: id,
            startedAt: startedAt,
            totalUnits: cached?.totalUnits ?? totalUnits,
            drinkCount: drinks?.count ?? 0,
            peakRange: cached?.peakRange,
            limit: limit
        )
    }
}

/// One drinking day, with what happened on it — or the fact that nothing did.
struct DayBucket: Identifiable, Hashable, Sendable {

    enum State: Hashable, Sendable {
        /// At least one session started on this day.
        case drank
        /// Recorded, and nothing was logged: evidence of not drinking.
        case dry
        /// Before records began. Not a dry day — we were not looking.
        case unknown
    }

    let day: DrinkingDay
    let state: State
    let occasions: [HistoryOccasion]

    var id: Date { day.id }

    var totalUnits: Double { occasions.reduce(0) { $0 + $1.totalUnits } }
    var drinkCount: Int { occasions.reduce(0) { $0 + $1.drinkCount } }

    /// The highest peak of the day, as a band. Nil when nothing was drunk or
    /// when no occasion has a valid cached peak.
    var peakRange: ClosedRange<Double>? {
        occasions.compactMap(\.peakRange).max { $0.upperBound < $1.upperBound }
    }

    /// False while any occasion of the day is waiting for its peak.
    var peakIsComplete: Bool {
        occasions.allSatisfy { $0.peakRange != nil }
    }

    /// The strictest limit in force that day, for colouring the day's peak.
    /// With one session — the usual case — it is simply that session's limit.
    var limit: Double? { occasions.map(\.limit).min() }
}

/// A week, month or year of days — or a single day, for the day view.
struct PeriodBucket: Identifiable, Hashable, Sendable {
    let period: HistoryPeriod
    let interval: DateInterval
    let days: [DayBucket]

    var id: Date { interval.start }

    var totalUnits: Double { days.reduce(0) { $0 + $1.totalUnits } }
    var drinkCount: Int { days.reduce(0) { $0 + $1.drinkCount } }

    var drinkingDays: Int { days.filter { $0.state == .drank }.count }
    var dryDays: Int { days.filter { $0.state == .dry }.count }
    var unknownDays: Int { days.filter { $0.state == .unknown }.count }

    /// Days we know something about — the denominator for any average.
    var recordedDays: Int { days.count - unknownDays }

    /// Units per recorded day. Nil when nothing about the period is known,
    /// so a caller cannot mistake "no data" for zero.
    var unitsPerRecordedDay: Double? {
        recordedDays > 0 ? totalUnits / Double(recordedDays) : nil
    }

    /// The highest peak of the period, and whether every day contributed.
    var peakRange: ClosedRange<Double>? {
        days.compactMap(\.peakRange).max { $0.upperBound < $1.upperBound }
    }

    var peakIsComplete: Bool { days.allSatisfy(\.peakIsComplete) }

    /// Change in total units against another period, as a fraction: +0.25 is a
    /// quarter more. Nil when the other period has nothing to compare against.
    func unitsChange(from previous: PeriodBucket) -> Double? {
        guard previous.recordedDays > 0, previous.totalUnits > 0 else { return nil }
        return (totalUnits - previous.totalUnits) / previous.totalUnits
    }
}
