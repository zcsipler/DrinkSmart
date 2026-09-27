import Foundation

/// Remembers the last day aggregate History built, and hands it back while
/// nothing that went into it has changed.
///
/// ## Why
///
/// `HistoryAggregate.days` is cheap per call — a few hundred sessions folded
/// into a few hundred days. What is not cheap is the input: mapping every
/// session to its `HistoryOccasion` touches the `drinks` relationship of each
/// one, and on a SwiftData model that is a fault the first time and a tracked
/// property access every time after. `HistoryView` used to rebuild the whole
/// thing in a computed property, once per body evaluation — so every scroll,
/// every segment change and every half-minute tick re-walked six years of
/// sessions. Fine for one season of data; with an imported history the screen
/// stuttered.
///
/// ## Key
///
/// The aggregate depends on exactly four things, and the key is exactly those:
///
/// - `SessionStore.revision`, which moves on every save and refresh — the only
///   way stored sessions change underneath the view;
/// - the person, since the sessions are theirs;
/// - their `trackingStartedAt`, which decides where `.unknown` ends;
/// - the current drinking day, because the aggregate runs up to today and
///   today moves at 05:00.
///
/// `now` itself is deliberately not in the key: within a day it changes
/// nothing in the aggregate, and it changes every thirty seconds.
///
/// A class rather than a struct so a view can hold it in `@State` and fill it
/// from `body` without a state write — which SwiftUI would answer with another
/// body evaluation.
@MainActor
final class HistoryAggregateCache {

    struct Key: Hashable {
        let revision: Int
        let personID: UUID
        let trackingStartedAt: Date
        let today: Date
    }

    private var key: Key?
    private var days: [DayBucket] = []

    init() {}

    /// The aggregate for `sessions`, rebuilt only when `key` differs from the
    /// one the stored aggregate was built for.
    ///
    /// `sessions` and `monthlyTotals` are taken as closures so the caller does
    /// not filter the person's rows out of the queries on the evaluations
    /// that hit the cache.
    func days(
        for key: Key,
        trackingStartedAt: Date,
        now: Date,
        calendar: Calendar = .current,
        sessions: () -> [DrinkingSession],
        monthlyTotals: () -> [MonthlyTotal] = { [] }
    ) -> [DayBucket] {
        if key == self.key { return days }

        days = HistoryAggregate.days(
            from: sessions().map(\.historyOccasion),
            knownMonths: monthlyTotals().map(\.asKnownMonth),
            trackingStartedAt: trackingStartedAt,
            now: now,
            calendar: calendar
        )
        self.key = key
        return days
    }

    /// Forgets the stored aggregate. Not needed in the ordinary flow — the key
    /// takes care of it — but cheap to offer for a test or a debug switch.
    func invalidate() {
        key = nil
        days = []
    }
}
