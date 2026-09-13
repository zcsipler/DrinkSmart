import SwiftUI
import BACKit

/// The list of drinks in a session, newest first.
///
/// Shared by the running session and the history detail, because editing a
/// three-week-old mistake should work exactly the way editing tonight's does.
struct DrinkListSection: View {
    let drinks: [Drink]
    @Binding var openRowID: UUID?
    let onEdit: (Drink) -> Void
    let onDelete: (Drink) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Drinks this session")
                    .font(.sectionLabel)
                    .textCase(.uppercase)
                Spacer()
                Text("tap to edit · swipe to delete")
                    .font(.system(size: 10, design: .rounded))
            }
            .foregroundStyle(Theme.secondaryText)

            VStack(spacing: 1) {
                ForEach(drinks.reversed()) { drink in
                    DrinkRow(
                        drink: drink,
                        openRowID: $openRowID,
                        onEdit: { onEdit(drink) },
                        onDelete: { onDelete(drink) }
                    )
                }
            }
            // Each row paints its own surface, so the 1 pt gaps left by the
            // stack spacing become hairline separators.
            .background(Theme.hairline)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
