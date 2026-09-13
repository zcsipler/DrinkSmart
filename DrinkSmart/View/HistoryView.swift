import SwiftUI
import SwiftData
import BACKit

/// Past drinking occasions, newest first.
///
/// Tapping one opens its curve — drawn with that session's own profile
/// snapshot, so it looks the way it actually was, not the way it would look if
/// you drank the same tonight.
///
/// The range picker and the aggregate figures come next; this first pass is
/// the list and the curve behind it.
struct HistoryView: View {
    let store: SessionStore

    /// Finished sessions only. The one in progress belongs to Today.
    @Query(
        filter: #Predicate<DrinkingSession> { $0.endedAt != nil },
        sort: \DrinkingSession.startedAt,
        order: .reverse
    )
    private var sessions: [DrinkingSession]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if sessions.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle(Text("History"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(sessions) { session in
                    NavigationLink {
                        SessionDetailView(session: session, store: store)
                    } label: {
                        SessionRow(session: session, unit: store.unit)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 26, weight: .light))
                .foregroundStyle(Theme.secondaryText.opacity(0.6))
            Text("No past sessions yet")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
            Text("A session appears here once it has ended — when your level has cleared and a few hours have passed.")
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 60)
    }
}

/// One line of history: when it was, how high it went, how much it was.
private struct SessionRow: View {
    let session: DrinkingSession
    let unit: BACUnit

    /// Falls back to computing when the stored summary is missing or was
    /// produced by an older engine version.
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
                    Text(verbatim: "·")
                    Text(verbatim: duration.compactDuration)
                    Text(verbatim: "·")
                    Text("\(summary.drinkCount.formatted()) drinks")
                }
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(verbatim: unit.formatRange(summary.peakRange))
                    .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                    .foregroundStyle(Theme.tint(for: summary.peakRange.upperBound))
                Text("peak")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.secondaryText)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.secondaryText.opacity(0.5))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    HistoryView(store: .preview)
}
