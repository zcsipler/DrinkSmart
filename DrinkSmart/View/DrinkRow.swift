import SwiftUI
import BACKit

/// One logged drink: tap to correct it, swipe left to delete.
///
/// This is a hand-rolled swipe rather than `List`'s `swipeActions`, because
/// the session list lives inside the main `ScrollView` and a nested `List`
/// would not size itself sensibly there.
struct DrinkRow: View {
    let drink: Drink

    /// Which row is currently swiped open. Shared across rows so that opening
    /// one closes the others.
    @Binding var openRowID: UUID?

    let onEdit: () -> Void
    let onDelete: () -> Void

    /// Live translation during the drag, added to the resting offset.
    @State private var dragTranslation: CGFloat = 0

    private let revealWidth: CGFloat = 78

    private var isOpen: Bool { openRowID == drink.id }

    private var offset: CGFloat {
        let resting = isOpen ? -revealWidth : 0
        // Rubber-band past the reveal width, and never drag to the right.
        return min(max(resting + dragTranslation, -revealWidth * 1.25), 0)
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            deleteBackground
            content
                .background(Theme.surface)
                .offset(x: offset)
                .gesture(swipe)
        }
        .clipped()
        .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.85), value: offset)
    }

    // MARK: Content

    private var content: some View {
        HStack(spacing: 13) {
            Image(systemName: DrinkCatalog.icon(for: drink))
                .font(.system(size: 15))
                .foregroundStyle(Theme.calm)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(DrinkCatalog.name(for: drink))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.primaryText)

                HStack(spacing: 4) {
                    Text(verbatim: "\(drink.volumeMl.formatted(.number.precision(.fractionLength(0)))) ml")
                    Text(verbatim: "·")
                    Text(verbatim: "\(drink.abvPercent.formatted(.number.precision(.fractionLength(1))))%")
                    Text(verbatim: "·")
                    Text(drink.stomach.shortLabel)
                    // Only when it was sipped: "in one go" is the quiet
                    // default and does not need saying on every row.
                    if drink.drinkingMinutes > 0 {
                        Text(verbatim: "·")
                        Text(verbatim: (drink.drinkingMinutes * 60).compactDuration)
                    }
                }
                .font(.system(size: 11, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Text(verbatim: drink.consumedAt.hourMinute)
                .font(.system(size: 13, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.secondaryText)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.secondaryText.opacity(0.5))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .contentShape(Rectangle())
        .onTapGesture {
            if isOpen {
                openRowID = nil     // a tap while open just closes the row
            } else {
                onEdit()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: Text("Edit drink"), onEdit)
        .accessibilityAction(named: Text("Delete"), onDelete)
    }

    // MARK: Delete affordance

    private var deleteBackground: some View {
        Button(role: .destructive) {
            openRowID = nil
            onDelete()
        } label: {
            VStack(spacing: 3) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 14))
                Text("Delete")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(width: revealWidth)
            .frame(maxHeight: .infinity)
            .background(Theme.elevated)
        }
        .buttonStyle(.plain)
        // Hidden from VoiceOver: the row itself exposes a Delete action, so
        // this would otherwise be announced twice.
        .accessibilityHidden(true)
    }

    // MARK: Gesture

    private var swipe: some Gesture {
        DragGesture(minimumDistance: 18, coordinateSpace: .local)
            .onChanged { value in
                // Ignore mostly-vertical drags so the enclosing ScrollView
                // keeps working.
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                dragTranslation = value.translation.width
            }
            .onEnded { value in
                defer { dragTranslation = 0 }
                guard abs(value.translation.width) > abs(value.translation.height) else { return }

                // Predicted end position lets a quick flick open the row even
                // when the finger did not travel the full distance.
                let predicted = (isOpen ? -revealWidth : 0) + value.predictedEndTranslation.width
                openRowID = predicted < -revealWidth / 2 ? drink.id : nil
            }
    }
}

@MainActor
private struct DrinkRowPreview: View {
    @State private var openRowID: UUID?
    private let store = SessionStore.preview

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 1) {
                ForEach(store.drinks) { drink in
                    DrinkRow(drink: drink, openRowID: $openRowID, onEdit: {}, onDelete: {})
                }
            }
            .background(Theme.hairline)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding()
        }
    }
}

#Preview {
    DrinkRowPreview()
}
