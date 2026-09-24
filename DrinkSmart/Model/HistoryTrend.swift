import Foundation

/// The whole recorded span as two curves: how much per day, and how high
/// when you did drink. Built for the Trend segment of the History screen,
/// where the user scrolls and pinches through years rather than paging.
///
/// Both curves are exponential moving averages. A plain moving average was
/// the obvious choice and the wrong one: with it a heavy evening drops out of
/// the curve N days later as a step, on a day when nothing happened. An EMA
/// lets it fade. Symmetric smoothing (Gaussian, LOESS) was ruled out too,
/// because it reads the days *after* a point, so the end of the curve would
/// keep moving as days went by. With an EMA the past is settled.
///
/// The two curves do not run over the same days, and that is the point:
///
/// - **Amount** runs over every recorded day, dry days as zero. A week off
///   pulls the curve down — that is what a habit changing looks like.
/// - **Peak** runs over drinking days only, stepping from one evening to the
///   next and flat in between. It answers "when you drink, how high do you
///   go" — whether control is slipping or improving — and how many sober
///   days sat between two evenings must not dilute that. Averaging the peak
///   over calendar days would fold frequency into intensity.
///
/// The half-life follows the zoom (`halfLife(forVisibleDays:)`): a curve
/// smoothed over a week is noise at a five-year zoom, and one smoothed over
/// a quarter is a flat line at a two-month zoom. The same number serves both
/// curves, counted in the days each one knows about — days for the amount,
/// drinking days for the peak.
struct HistoryTrend: Hashable, Sendable {

    struct Point: Hashable, Sendable, Identifiable {
        let day: DrinkingDay
        let value: Double

        var id: Date { day.id }
    }

    /// The smoothing in force: days for `amount`, drinking days for `peak`.
    let halfLife: Int

    /// Standard units per day, smoothed; one point per recorded day.
    let amount: [Point]

    /// Peak level in g/L, smoothed; one point per drinking day with a known
    /// peak. Days whose peak is still being recomputed (a stale cache) are
    /// left out rather than guessed at.
    let peak: [Point]

    /// The peaks themselves, unsmoothed, for the dots under the curve.
    let peaks: [Point]

    // MARK: Building

    /// The three zoom bands and their smoothing. Under three months on
    /// screen a week; under two years a month; beyond that a quarter.
    static func halfLife(forVisibleDays days: Int) -> Int {
        if days < 90 { return 7 }
        if days < 730 { return 30 }
        return 90
    }

    /// - Parameter days: the continuous day list from `HistoryAggregate.days`,
    ///   oldest first. Days before records began carry nothing and are
    ///   skipped — a curve cannot start on a day we were not looking.
    static func make(days: [DayBucket], halfLife: Int) -> HistoryTrend {
        let recorded = days.filter { $0.state != .unknown }

        let amountValues = ema(recorded.map(\.totalUnits), halfLife: halfLife)
        let amount = zip(recorded, amountValues).map { Point(day: $0.day, value: $1) }

        let drinking = recorded.compactMap { day -> Point? in
            guard day.state == .drank, let peak = day.peakRange else { return nil }
            return Point(day: day.day, value: peak.midpoint)
        }
        let peakValues = ema(drinking.map(\.value), halfLife: halfLife)
        let peak = zip(drinking, peakValues).map { Point(day: $0.day, value: $1) }

        return HistoryTrend(halfLife: halfLife, amount: amount, peak: peak, peaks: drinking)
    }

    /// Exponential moving average with the given half-life, in samples. The
    /// first sample is its own average: there is nothing before it to fade.
    static func ema(_ values: [Double], halfLife: Int) -> [Double] {
        guard let first = values.first else { return [] }
        let alpha = 1 - pow(0.5, 1 / Double(max(halfLife, 1)))
        var result: [Double] = [first]
        result.reserveCapacity(values.count)
        for value in values.dropFirst() {
            result.append(alpha * value + (1 - alpha) * result[result.count - 1])
        }
        return result
    }
}
