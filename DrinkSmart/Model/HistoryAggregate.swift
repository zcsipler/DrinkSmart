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

    /// The days from the earliest of `trackingStartedAt`, the first occasion
    /// and the first month known by total, up to and including the day
    /// containing `now`, oldest first.
    ///
    /// Continuous on purpose: a dry day is a row too. A chart that only knew
    /// the days you drank could not show the ones you did not.
    ///
    /// ## Months known only as a total
    ///
    /// A `KnownMonth` (from `MonthlyTotal`) says how much was drunk in a month
    /// and nothing about which days. It applies to the days **before records
    /// began** — the ones that would otherwise be `.unknown` — and those days
    /// stay unknown: not dry, we were not looking. But each carries the month
    /// as a `SummarizedMonth`, so a bar or a figure built over them can show
    /// the sum. The rules:
    ///
    /// - `recordsBegan` — where `.unknown` turns into `.dry` — is still the
    ///   earlier of the stored start and the first occasion. Totals extend
    ///   how far back the list goes, not how far back records were kept.
    /// - A month that has both a total and occasions (records began partway
    ///   through it, or a drink was filled in on one of its days) keeps the
    ///   total: the occasions are the days we know, and what the total has
    ///   left over is the unknown days' share. Nothing is counted twice, and
    ///   filling in one evening never makes the month's figure disappear.
    /// - A month recorded as **zero** makes its unknown days `.dry`: that the
    ///   sum is nothing is the same as every day being nothing, and it is the
    ///   one inference from monthly to daily that holds.
    static func days(
        from occasions: [HistoryOccasion],
        knownMonths: [KnownMonth] = [],
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

        // A recorded evening is proof that records were being kept that day —
        // the same rule as `Person.backdateTracking`. So records begin on the
        // earlier of the stored start and the first occasion, and the days we
        // were not looking are always one run at the front, never a gap
        // between two evenings.
        let recordsBegan = ([trackingDay] + byDay.keys).min { $0.start < $1.start } ?? today

        // Which month a drinking day is filed under, by the day's own date
        // (the 05:00 start), the same way `HistoryPeriod` files it.
        func monthStart(of day: DrinkingDay) -> Date {
            calendar.dateInterval(of: .month, for: day.calendarDate)?.start ?? day.calendarDate
        }

        // Totals that apply: a real month, with at least one day before
        // records began — a month entirely inside the recorded span has
        // nothing left to explain. Keyed by the month's first day; when the
        // same month is listed twice the first one wins, as in the import.
        var totalByMonth: [Date: KnownMonth] = [:]
        for known in knownMonths {
            guard let interval = known.interval(calendar: calendar),
                  interval.start < recordsBegan.calendarDate,
                  totalByMonth[interval.start] == nil
            else { continue }
            totalByMonth[interval.start] = known
        }

        let firstKnownMonth = totalByMonth.keys.min().map {
            DrinkingDay.containing($0.addingTimeInterval(Double(DrinkingDay.boundaryHour) * 3600), calendar: calendar)
        }
        let firstDay = [recordsBegan, firstKnownMonth].compactMap { $0 }.min { $0.start < $1.start } ?? today
        guard firstDay.start <= today.start else { return [] }

        // First pass: what each month's occasions add up to, and how many of
        // its days are unknown — the two numbers a `SummarizedMonth` needs.
        var occasionUnits: [Date: Double] = [:]
        var unknownDayCount: [Date: Int] = [:]
        do {
            var day = firstDay
            while day.start <= today.start {
                let month = monthStart(of: day)
                if let dayOccasions = byDay[day] {
                    occasionUnits[month, default: 0] += dayOccasions.reduce(0) { $0 + $1.totalUnits }
                } else if day.start < recordsBegan.start {
                    unknownDayCount[month, default: 0] += 1
                }
                day = day.offset(by: 1, calendar: calendar)
            }
        }
        let summarized: [Date: SummarizedMonth] = totalByMonth.reduce(into: [:]) { result, entry in
            let (start, known) = entry
            result[start] = SummarizedMonth(
                month: known,
                unknownDays: unknownDayCount[start] ?? 0,
                remainderUnits: max(0, known.totalUnits - (occasionUnits[start] ?? 0))
            )
        }

        var result: [DayBucket] = []
        var day = firstDay
        while day.start <= today.start {
            let occasions = (byDay[day] ?? []).sorted { $0.startedAt < $1.startedAt }
            let beforeRecords = day.start < recordsBegan.start
            let month = beforeRecords ? summarized[monthStart(of: day)] : nil
            let state: DayBucket.State = if !occasions.isEmpty {
                .drank
            } else if let month, month.isZero {
                .dry
            } else if beforeRecords {
                .unknown
            } else {
                .dry
            }
            result.append(DayBucket(day: day, state: state, occasions: occasions, summarizedMonth: month))
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

    /// The month's total, on a day before records began that such a total
    /// covers. Nil on every recorded day. Set on `.dry` days too when the
    /// month was recorded as zero — the day is dry *because* of the total,
    /// and a view may want to say so.
    var summarizedMonth: SummarizedMonth? = nil

    var id: Date { day.id }

    /// Units from this day's occasions. A day covered by a month's total
    /// contributes nothing here — its share of the month is not known — and
    /// the month's remainder is added once, by `[DayBucket].totalUnits`, when
    /// the list holds all of that month's unknown days.
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

/// A month's total as it applies to the days before records began — what a
/// `DayBucket` in such a month carries. Built by `HistoryAggregate.days`.
struct SummarizedMonth: Hashable, Sendable {
    let month: KnownMonth

    /// How many of the month's days are before records began — the days the
    /// total speaks for. The whole month, usually; fewer when records began
    /// partway through it.
    let unknownDays: Int

    /// What the total has left after the month's occasions: the unknown days'
    /// share. The whole total when there are no occasions; never negative —
    /// a total smaller than what was logged is a stale figure, and the
    /// occasions are believed.
    let remainderUnits: Double

    var gramsEthanol: Double { month.gramsEthanol }
    var isZero: Bool { month.gramsEthanol <= 0 }
}

// MARK: - Sums over days

extension Array where Element == DayBucket {

    /// The summarized months these days touch, each once, in order. Zero
    /// months included: their days are dry days *and* a summarized month.
    var summarizedMonths: [SummarizedMonth] {
        var seen: Set<SummarizedMonth> = []
        return compactMap { day in
            guard let month = day.summarizedMonth, seen.insert(month).inserted else { return nil }
            return month
        }
    }

    /// The summarized months all of whose unknown days are in this list —
    /// the only ones whose remainder may be added to a sum over these days.
    /// A week straddling such a month knows the month's total but not the
    /// week's share of it, and must not claim the whole.
    var wholeSummarizedMonths: [SummarizedMonth] {
        var counts: [SummarizedMonth: Int] = [:]
        for day in self {
            if let month = day.summarizedMonth { counts[month, default: 0] += 1 }
        }
        return summarizedMonths.filter { counts[$0] == $0.unknownDays }
    }

    /// Units from monthly totals, whole months only.
    var coarseUnits: Double {
        wholeSummarizedMonths.reduce(0) { $0 + $1.remainderUnits }
    }

    /// Days spoken for by a whole summarized month — unknown day by day, but
    /// accounted for by the month. Zero months are not here: their days are
    /// `.dry`, and already counted as recorded.
    var coarseDays: Int {
        let whole = Set(wholeSummarizedMonths)
        return filter { day in
            guard day.state == .unknown, let month = day.summarizedMonth else { return false }
            return whole.contains(month)
        }.count
    }

    /// Units from occasions plus the remainders of whole summarized months.
    /// The two never overlap: a remainder is the total *after* the month's
    /// occasions (see `HistoryAggregate.days`).
    var totalUnits: Double {
        reduce(0) { $0 + $1.totalUnits } + coarseUnits
    }

    /// Whether anything at all is known about these days — an occasion, a dry
    /// day, or a month's total.
    var isRecorded: Bool {
        contains { $0.state != .unknown || $0.summarizedMonth != nil }
    }
}

/// A week, month or year of days — or a single day, for the day view.
struct PeriodBucket: Identifiable, Hashable, Sendable {
    let period: HistoryPeriod
    let interval: DateInterval
    let days: [DayBucket]

    var id: Date { interval.start }

    var totalUnits: Double { days.totalUnits }
    var drinkCount: Int { days.reduce(0) { $0 + $1.drinkCount } }

    var drinkingDays: Int { days.filter { $0.state == .drank }.count }
    var dryDays: Int { days.filter { $0.state == .dry }.count }
    var unknownDays: Int { days.filter { $0.state == .unknown }.count }

    /// Months in this period known only by total. Their days are among the
    /// unknown ones, but the period is not blank — see `totalUnits`.
    var summarizedMonths: [SummarizedMonth] { days.summarizedMonths }

    /// Days we know something about — the denominator for any average.
    var recordedDays: Int { days.count - unknownDays }

    /// Units per recorded day. Nil when nothing about the period is known,
    /// so a caller cannot mistake "no data" for zero.
    ///
    /// Months known only by total count with all their days: the sum is
    /// theirs, so the denominator must be theirs too, or a year of totals
    /// with one week of records would read as a week of heavy drinking.
    var unitsPerRecordedDay: Double? {
        let denominator = recordedDays + days.coarseDays
        return denominator > 0 ? totalUnits / Double(denominator) : nil
    }

    /// The highest peak of the period, and whether every day contributed.
    var peakRange: ClosedRange<Double>? {
        days.compactMap(\.peakRange).max { $0.upperBound < $1.upperBound }
    }

    var peakIsComplete: Bool { days.allSatisfy(\.peakIsComplete) }

    /// Change in total units against another period, as a fraction: +0.25 is a
    /// quarter more. Nil when the other period has nothing to compare against.
    func unitsChange(from previous: PeriodBucket) -> Double? {
        guard previous.days.isRecorded, previous.totalUnits > 0 else { return nil }
        return (totalUnits - previous.totalUnits) / previous.totalUnits
    }
}
