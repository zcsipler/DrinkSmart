import SwiftUI
import BACKit

/// The floating controls at the bottom of the Live screen.
///
/// Two capsules, not one split in half. "Add drink" stays exactly what it was,
/// and the quick add sits next to it as its own thing — a shortcut that is
/// visibly a second button rather than an edge of the first one. Both at thumb
/// height, for the reason the single capsule always was: this happens
/// one-handed, in a bar.
///
/// The quick capsule is on the **right**. It is the more frequent of the two
/// and the right side is the shorter reach for a right-handed thumb; it is also
/// the one that carries colour, so it reads as the primary action wherever the
/// eye lands first.
///
/// ## Why the projected peak is on the button
///
/// The app exists because the decision is made *before* the drink is poured,
/// and a forward simulation is what intervenes there (2., 5.10). A one-tap add
/// would ordinarily remove that intervention and leave a retrospective unit
/// counter, which is the thing the product is explicitly not.
///
/// Printing the projected peak on the button keeps it. The figure is under the
/// thumb at the moment of pressing, and the fill is the level colour for that
/// peak — the same tint the sheet's Add button already uses, so a drink that
/// would cross the limit turns the control red before it is pressed rather than
/// after.
///
/// **Always a single number**, even when the readout elsewhere is showing a
/// range (5.8). A range is about twice as wide, and a capsule whose width
/// depends on an unrelated setting is a capsule that eventually truncates.
///
/// ## Why the figure is not on the quick capsule
///
/// It was, twice: first as a bare `+ 1.94 ‰`, which told a first-time reader
/// neither what would be added nor what the number meant, and then on a second
/// line under the drink's name, labelled. The second version was readable and
/// still wrong, because everything had to shrink to fit — and the one moment
/// this button exists for is the moment its reader is least able to read small
/// text.
///
/// So the capsule says what it would add, in the largest type that fits, and
/// nothing else. **The colour carries the projection.** That is not a
/// concession: `Theme.tint` is anchored to this person's own limit (5.14), so
/// full red lands exactly on the line they drew, and "would this take me over"
/// is answered continuously, before the press, at a glance. What the figure has
/// that the colour does not is resolution — and nobody needs to tell 0.44 from
/// 0.47 while deciding on the next pint. The exact number is on screen a second
/// later, in the strip and on the readout above.
///
/// The one thing the colour cannot do is reach someone who cannot see it, so
/// the limit warning is repeated as a glyph — the same three-state vocabulary
/// the sheet uses (5.2), and readable in conditions where a number is not.
struct QuickAddBar: View {
    let store: SessionStore

    /// What the quick button would log. Nil means there is nothing to offer —
    /// no favourite and nothing ever recorded — and then there is only one
    /// capsule, exactly as before.
    let offer: QuickAddOffer?

    let onQuickAdd: () -> Void
    let onOpenSheet: () -> Void

    /// Computed once here and passed down, rather than read from `store` in
    /// several places: `project` is six simulations behind a cache, and a cache
    /// a caller can miss is one that does not help (8.).
    private var projection: BandedProjection? {
        offer.map { store.project($0.drink) }
    }

    private var tint: Color {
        guard let projection else { return Theme.calm }
        return Theme.tint(for: projection.peakRange.upperBound, limit: store.limit)
    }

    var body: some View {
        HStack(spacing: 10) {
            addDrinkButton

            if let offer, let projection {
                quickButton(offer: offer, projection: projection)
            }
        }
        // The quick capsule is the taller of the two and decides the height;
        // `addDrinkButton` is the flexible one and grows to match. Without the
        // fixed size the pair would stretch to fill the whole overlay.
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: Theme.background.opacity(0.7), radius: 16, y: 6)
        .padding(.bottom, 12)
        .animation(.easeOut(duration: 0.25), value: tint)
    }

    // MARK: The button that was always here

    private var addDrinkButton: some View {
        Button(action: onOpenSheet) {
            HStack(spacing: 9) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                Text("Add drink")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(Theme.background)
            .padding(.horizontal, 20)
            .padding(.vertical, 13)
            .frame(maxHeight: .infinity)
            .background(Theme.calm, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: The shortcut

    private func quickButton(offer: QuickAddOffer, projection: BandedProjection) -> some View {
        Button(action: onQuickAdd) {
            HStack(spacing: 9) {
                Image(systemName: DrinkCatalog.icon(for: offer.drink))
                    .font(.system(size: 18, weight: .semibold))

                Text(DrinkCatalog.name(for: offer.drink))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))

                Text(verbatim: volumeLabel(offer.drink))
                    .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                    .opacity(0.72)

                if let glyph = warningGlyph(projection) {
                    Image(systemName: glyph)
                        .font(.system(size: 13, weight: .semibold))
                }
            }
            .foregroundStyle(Theme.background)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .padding(.horizontal, 18)
            .padding(.vertical, 13)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .background(tint, in: Capsule())
        }
        .buttonStyle(.plain)
        // The visible label says what would be added; what it deliberately does
        // not say is the figure, which is carried by a colour. VoiceOver gets
        // the figure instead — a reader who is not glancing at a capsule in a
        // dark bar is the one reader for whom the number is the better channel.
        .accessibilityValue(Text("Peak \(Text(verbatim: store.unit.formatted(projection.peakRange.midpoint)))"))
        .accessibilityHint(Text("Logs it straight away, without opening anything."))
    }

    /// The limit warning as a shape rather than a colour, in the sheet's own
    /// three-state vocabulary (5.2). Nothing at all when the drink is not going
    /// to take anyone anywhere near their line, which is most of the time.
    private func warningGlyph(_ projection: BandedProjection) -> String? {
        switch projection.outcome {
        case .above: "exclamationmark.triangle.fill"
        case .uncertain: "questionmark.circle.fill"
        case .below: nil
        }
    }

    private func volumeLabel(_ drink: Drink) -> String {
        "\(drink.volumeMl.formatted(.number.precision(.fractionLength(0)))) ml"
    }
}

/// What appears for a few seconds after a quick add.
///
/// It does two jobs, and both exist because the tap asked no questions.
///
/// **Undo.** A control this fast gets pressed by accident, and an accidental
/// drink does not just add alcohol that was never drunk — it also shortens the
/// previous drink to the gap between the two taps (5.13), which is where the
/// false steepness comes from. `SessionStore.undoQuickAdd` puts both back.
///
/// **The stomach state.** It is the one input the favourite does not carry, so
/// the quick add inherits it from the previous drink and falls back to
/// `.light`. Inheritance chains: an empty stomach at seven is still an empty
/// stomach at eleven as far as the chain is concerned, by which time you have
/// eaten. Three taps' worth of correction, offered rather than demanded, is the
/// way out — and it is offered at the only moment when the answer is actually
/// in mind.
/// It also carries the third job, and only when there is one to carry:
///
/// **Making it the favourite.** When the add came from a repeat rather than
/// from a standing choice, the moment the drink is in front of you is the best
/// one there will ever be to ask whether it is the usual order. Offered here
/// rather than demanded at first launch — a questionnaire before the app has
/// even been used would ask the wrong question first anyway, since the body
/// profile is what actually decides whether the curve is right.
struct QuickAddStrip: View {
    let receipt: QuickAddReceipt
    let onCorrect: (StomachState) -> Void
    let onSetDefault: () -> Void
    let onUndo: () -> Void

    @State private var stomach: StomachState

    /// Local, so the row can confirm itself and stay confirmed for the few
    /// seconds the strip has left.
    @State private var madeDefault = false

    init(
        receipt: QuickAddReceipt,
        onCorrect: @escaping (StomachState) -> Void,
        onSetDefault: @escaping () -> Void,
        onUndo: @escaping () -> Void
    ) {
        self.receipt = receipt
        self.onCorrect = onCorrect
        self.onSetDefault = onSetDefault
        self.onUndo = onUndo
        _stomach = State(initialValue: receipt.drink.stomach)
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.calm)

                Text("\(Text(DrinkCatalog.name(for: receipt.drink))) added")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.primaryText)
                    .lineLimit(1)

                Spacer(minLength: 8)

                Button(action: onUndo) {
                    Text("Undo")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.calm)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 8) {
                Text("Stomach")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.secondaryText)

                Spacer(minLength: 6)

                ForEach(StomachState.allCases, id: \.self) { state in
                    stomachButton(state)
                }
            }

            if receipt.source == .lastDrink {
                Divider().overlay(Theme.hairline)
                setDefaultRow
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Theme.surfaceRaised, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16).stroke(Theme.hairline, lineWidth: 1)
        }
        .shadow(color: Theme.background.opacity(0.7), radius: 14, y: 5)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    private var setDefaultRow: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) { madeDefault = true }
            onSetDefault()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: madeDefault ? "star.fill" : "star")
                    .font(.system(size: 12))
                if madeDefault {
                    Text("This is now your usual")
                } else {
                    Text("Always add this one")
                }
                Spacer()
            }
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundStyle(madeDefault ? Theme.secondaryText : Theme.calm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(madeDefault)
    }

    private func stomachButton(_ state: StomachState) -> some View {
        let isSelected = stomach == state

        return Button {
            withAnimation(.easeOut(duration: 0.15)) { stomach = state }
            onCorrect(state)
        } label: {
            HStack(spacing: 5) {
                Image(systemName: state.icon)
                    .font(.system(size: 11))
                Text(state.shortLabel)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(
                isSelected ? Theme.calm.opacity(0.18) : Theme.surface,
                in: RoundedRectangle(cornerRadius: 9)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 9)
                    .stroke(isSelected ? Theme.calm : Theme.hairline, lineWidth: 1)
            }
            .foregroundStyle(isSelected ? Theme.calm : Theme.secondaryText)
        }
        .buttonStyle(.plain)
    }
}
