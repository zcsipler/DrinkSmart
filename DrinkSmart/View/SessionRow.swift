import SwiftUI
import BACKit

/// One line of history: when it was, how high it went, how much it was.
///
/// Locked, the row still says *that* there was an evening, and when — the
/// date is what tells a free user there is something behind the lock. What it
/// withholds is the reading: the peak, the count, and the curve behind the row.
struct SessionRow: View {
    let session: DrinkingSession
    let unit: BACUnit
    var locked = false

    /// Falls back to computing when the stored summary is missing or was
    /// produced by an older engine version. One row at a time, on screen, is
    /// cheap; the store refills the cache in the background regardless.
    private var summary: SessionSummary {
        if let stored = session.summary { return stored }

        let drinks = session.sortedDrinks
        let band = drinks.isEmpty
            ? BACBand.empty
            : BACEngine().simulateBand(profile: session.profile, drinks: drinks)

        return SessionSummary(
            peakRange: band.peakRange ?? 0...0,
            soberAt: band.soberRange()?.upperBound,
            totalUnits: session.totalUnits,
            drinkCount: drinks.count
        )
    }

    private var duration: TimeInterval {
        guard let end = session.endedAt else { return 0 }
        return max(end.timeIntervalSince(session.startedAt), 0)
    }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: session.startedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.primaryText)

                HStack(spacing: 4) {
                    Text(verbatim: session.startedAt.hourMinute)
                    if !locked {
                        Text(verbatim: "·")
                        Text(verbatim: duration.compactDuration)
                        Text(verbatim: "·")
                        Text("\(summary.drinkCount.formatted()) drinks")
                    }
                }
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            if locked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.secondaryText.opacity(0.7))
            } else {
                VStack(alignment: .trailing, spacing: 3) {
                    Text(verbatim: unit.formatRange(summary.peakRange))
                        .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.tint(for: summary.peakRange.midpoint, limit: session.limit))
                    Text("peak")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .textCase(.uppercase)
                        .foregroundStyle(Theme.secondaryText)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Theme.secondaryText.opacity(0.5))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14))
    }
}
