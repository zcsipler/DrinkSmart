import SwiftUI
import BACKit

/// A stored session rendered in full: its curve, its figures, its drinks.
///
/// Shared by the history detail and by the Live screen when you page back to a
/// past day, so a previous evening looks the same wherever you reach it from.
///
/// Everything comes from the session's own profile snapshot. Changing your
/// weight today does not redraw last month.
struct SessionContentView: View {
    let session: DrinkingSession
    let store: SessionStore

    /// Set when the user taps a drink to correct it.
    @Binding var editingDrink: Drink?
    @Binding var openRowID: UUID?

    /// Shows which profile produced this curve. Off inside the Live screen,
    /// where several days scroll past and the note would just repeat.
    var showsProfileNote: Bool = true

    /// Recomputing the band is three simulations, too much for every body
    /// evaluation. Refreshed when the drinks actually change.
    @State private var model: BACChartModel?

    private var drinks: [Drink] { session.sortedDrinks }

    /// Changes whenever any drink's values change, not only when one is added
    /// or removed — `Drink` hashes all of its properties.
    private var contentSignature: Int {
        var hasher = Hasher()
        hasher.combine(drinks)
        hasher.combine(store.unit)
        return hasher.finalize()
    }

    var body: some View {
        VStack(spacing: 26) {
            if let model {
                BACChartView(model: model)
            }
            statRow
            if !drinks.isEmpty {
                DrinkListSection(
                    drinks: drinks,
                    openRowID: $openRowID,
                    onEdit: { editingDrink = $0 },
                    onDelete: { drink in
                        withAnimation { store.remove(drink, from: session) }
                    }
                )
            }
            if showsProfileNote {
                profileNote
            }
        }
        .onAppear { refresh() }
        .onChange(of: contentSignature) { refresh() }
    }

    private func refresh() {
        model = session.chartModel(unit: store.unit)
    }

    // MARK: Stats

    private var statRow: some View {
        HStack(spacing: 0) {
            stat("Started", session.startedAt.hourMinute)
            divider
            stat("Lasted", duration.compactDuration)
            divider
            stat("Drinks", drinks.count.formatted())
            divider
            stat(store.amountUnit.shortLabel, store.amountUnit.format(standardUnits: session.totalUnits))
        }
        .padding(.vertical, 14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    private var duration: TimeInterval {
        guard let end = session.endedAt else { return 0 }
        return max(end.timeIntervalSince(session.startedAt), 0)
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.hairline)
            .frame(width: 1, height: 26)
    }

    private func stat(_ title: LocalizedStringResource, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: value)
                .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Snapshot note
    //
    // Makes the frozen profile visible. Without it, a user who has since
    // changed weight would have no way to tell why an old curve looks the way
    // it does — or reason to trust that it was not silently rewritten.

    private var profileNote: some View {
        VStack(spacing: 4) {
            Text("Calculated with your profile at the time")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
            Text(verbatim: snapshotDescription)
                .font(.system(size: 11, design: .rounded).monospacedDigit())
        }
        .foregroundStyle(Theme.secondaryText)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.surface.opacity(0.6), in: RoundedRectangle(cornerRadius: 14))
    }

    private var snapshotDescription: String {
        let profile = session.profile
        let weight = profile.weightKg.formatted(.number.precision(.fractionLength(0)))
        let height = profile.heightCm.formatted(.number.precision(.fractionLength(0)))
        let beta = store.unit.formatted(profile.beta)
        return "\(weight) kg · \(height) cm · \(beta)/h"
    }
}
