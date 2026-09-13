import Foundation
import BACKit

/// Everything the curve needs to draw itself, from either the running session
/// or a stored one.
///
/// The chart used to read `SessionStore` directly, which meant it could only
/// ever show tonight. This value type is the seam: the live store produces one,
/// and so does a `DrinkingSession` out of the history — with that session's own
/// profile snapshot, so a past evening is drawn as it actually was.
struct BACChartModel {
    let band: BACBand
    let drinks: [Drink]
    let limit: Double
    let unit: BACUnit

    /// Where the marker and the readout sit. `nil` on a finished session,
    /// which has no "now" worth pointing at.
    let focusDate: Date?

    /// Live sessions get the "still rising" badge and a dashed now-line;
    /// finished ones do not, because neither means anything in the past.
    let isLive: Bool

    // MARK: Derived

    var peak: BACSample? { band.peak }
    var peakRange: ClosedRange<Double>? { band.peakRange }
    var soberRange: ClosedRange<Date>? { drinks.isEmpty ? nil : band.soberRange() }

    /// The peak is only "expected" while it is still ahead of us.
    var upcomingPeak: BACSample? {
        guard isLive, let focusDate, let peak,
              peak.date > focusDate.addingTimeInterval(60)
        else { return nil }
        return peak
    }

    var currentRange: ClosedRange<Double> {
        guard let focusDate, !drinks.isEmpty else { return 0...0 }
        return band.range(at: focusDate)
    }

    var currentBAC: Double {
        guard let focusDate, !drinks.isEmpty else { return 0 }
        return band.value(at: focusDate)
    }

    var currentRate: Double {
        guard let focusDate else { return 0 }
        return band.center.samples.last { $0.date <= focusDate }?.rate ?? 0
    }

    var isRising: Bool { isLive && !drinks.isEmpty && currentRate > 0.01 }

    /// The window to plot.
    ///
    /// A live session is padded to at least six hours so the curve has room to
    /// grow into; a finished one is framed to what actually happened.
    var visibleRange: ClosedRange<Date> {
        let first = drinks.map(\.consumedAt).min() ?? focusDate ?? .now
        let start = first.addingTimeInterval(-15 * 60)

        let natural = soberRange?.upperBound
            ?? focusDate?.addingTimeInterval(4 * 3600)
            ?? start.addingTimeInterval(6 * 3600)
        var end = natural.addingTimeInterval(20 * 60)

        if isLive {
            end = max(end, start.addingTimeInterval(6 * 3600))
        }
        return start...max(end, start.addingTimeInterval(3600))
    }

    var yMaximum: Double {
        max((peakRange?.upperBound ?? 0) * 1.3, limit * 1.4, 0.5)
    }
}

// MARK: - Producers

extension SessionStore {
    /// The running session, as the chart sees it.
    var chartModel: BACChartModel {
        BACChartModel(
            band: band,
            drinks: drinks,
            limit: limit,
            unit: unit,
            focusDate: now,
            isLive: true
        )
    }
}

extension DrinkingSession {
    /// A stored session, recomputed with **its own** profile snapshot.
    ///
    /// Not the current profile: that is the whole point of storing the
    /// snapshot. Changing your weight today must not redraw last month.
    func chartModel(unit: BACUnit, engine: BACEngine = BACEngine()) -> BACChartModel {
        let drinks = sortedDrinks
        return BACChartModel(
            band: drinks.isEmpty ? .empty : engine.simulateBand(profile: profile, drinks: drinks),
            drinks: drinks,
            limit: limit,
            unit: unit,
            focusDate: nil,
            isLive: false
        )
    }
}
