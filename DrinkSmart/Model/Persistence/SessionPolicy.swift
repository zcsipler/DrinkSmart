import Foundation
import BACKit

/// When one drinking occasion ends and the next begins.
///
/// This lives in its own type rather than as scattered conditions in the store,
/// because it is the rule that decides how the whole history is carved up. Get
/// it wrong in one direction and a week collapses into a single session; get it
/// wrong in the other and one evening is split in three.
///
/// The rule: **a session stays open while there is still alcohol in the system,
/// or the last drink is recent.** People forget to close a session manually, so
/// this is evaluated on launch and on returning to the foreground, not only
/// when a drink is logged.
enum SessionPolicy {

    /// How long after the level has cleared a session still accepts drinks.
    ///
    /// A short break — leaving one bar for another — should not start a new
    /// session. Three hours is long enough to cover that and short enough that
    /// tomorrow's first drink is clearly a new occasion.
    static let graceAfterClearing: TimeInterval = 3 * 3600

    /// The level below which the session counts as cleared.
    static let clearedThreshold = 0.01

    /// Whether a session running up to `date` should still be considered open.
    ///
    /// - Parameters:
    ///   - lastDrinkAt: the most recent drink in the session, if any
    ///   - soberAt: when the slow branch of the band reaches zero
    ///   - date: the moment being evaluated, normally now
    static func isStillOpen(lastDrinkAt: Date?, soberAt: Date?, at date: Date) -> Bool {
        guard let lastDrinkAt else {
            // An empty session has nothing to close yet.
            return true
        }

        // Still absorbing or eliminating.
        if let soberAt, date < soberAt { return true }

        // Cleared, but recently enough that this is the same occasion.
        let reference = soberAt ?? lastDrinkAt
        return date.timeIntervalSince(reference) < graceAfterClearing
    }

    /// The moment a session ended, for the record.
    ///
    /// The clearing time if we have one, otherwise the last drink — never
    /// "now", which would depend on when the app happened to be opened.
    static func closingDate(lastDrinkAt: Date?, soberAt: Date?) -> Date? {
        soberAt ?? lastDrinkAt
    }

    /// Convenience over a computed band.
    static func isStillOpen(band: BACBand, lastDrinkAt: Date?, at date: Date) -> Bool {
        isStillOpen(
            lastDrinkAt: lastDrinkAt,
            soberAt: band.soberRange(threshold: clearedThreshold)?.upperBound,
            at: date
        )
    }
}
