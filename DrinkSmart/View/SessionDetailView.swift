import SwiftUI
import BACKit

/// One past evening, reached from the history list.
///
/// The content is shared with the Live screen — see `SessionContentView`.
/// This is only the navigation wrapper around it, and it stays the bottom of
/// the history drill-down: year → month → week → day → this.
struct SessionDetailView: View {
    let session: DrinkingSession
    let store: SessionStore

    @State private var editingDrink: Drink?
    @State private var openRowID: UUID?

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                SessionContentView(
                    session: session,
                    store: store,
                    editingDrink: $editingDrink,
                    openRowID: $openRowID
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(Text(verbatim: session.startedAt.formatted(date: .abbreviated, time: .omitted)))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingDrink) { drink in
            AddDrinkSheet(store: store, editing: drink, session: session)
        }
        .onChange(of: editingDrink?.id) { openRowID = nil }
    }
}
