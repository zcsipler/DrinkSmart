import SwiftUI
import BACKit

/// The profile row that sets what the quick-add button logs.
///
/// A standing choice rather than something inferred from history, and that is
/// the point of it: an evening that goes beer, pálinka, Jäger has no sensible
/// "same again", so repeating the last drink would be wrong exactly when the
/// button is most tempting. What someone usually orders is a fact about them,
/// and they are the one who knows it.
struct FavouriteDrinkSection: View {
    let store: SessionStore

    @State private var isEditing = false

    var body: some View {
        Section {
            Button {
                isEditing = true
            } label: {
                if let favourite = store.favourite {
                    chosen(favourite)
                } else {
                    unset
                }
            }
            .buttonStyle(.plain)
        } header: {
            Text("Quick add")
        } footer: {
            if store.favourite == nil {
                Text("Pick the drink you usually order, and a button on the Live screen will log it in one tap.")
            } else {
                Text("One tap on the Live screen logs this, with the projected peak on the button. How full your stomach is comes from the drink before it, and can be corrected straight after.")
            }
        }
        .listRowBackground(Theme.surface)
        .sheet(isPresented: $isEditing) {
            FavouriteDrinkSheet(store: store)
        }
    }

    private func chosen(_ favourite: FavouriteDrink) -> some View {
        HStack(spacing: 12) {
            Image(systemName: favourite.template.icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.calm)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(favourite.template.name)
                    .foregroundStyle(Theme.primaryText)

                Text(verbatim: summary(favourite))
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Theme.secondaryText.opacity(0.5))
        }
    }

    private var unset: some View {
        HStack(spacing: 12) {
            Image(systemName: "star")
                .font(.system(size: 16))
                .foregroundStyle(Theme.secondaryText)
                .frame(width: 24)

            Text("Choose a favourite drink")
                .foregroundStyle(Theme.primaryText)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Theme.secondaryText.opacity(0.5))
        }
    }

    private func summary(_ favourite: FavouriteDrink) -> String {
        let volume = favourite.volumeMl.formatted(.number.precision(.fractionLength(0)))
        let abv = favourite.abvPercent.formatted(.number.precision(.fractionLength(1)))
        let pace = favourite.drinkingMinutes <= 0
            ? String(localized: "In one go")
            : (favourite.drinkingMinutes * 60).compactDuration
        return "\(volume) ml · \(abv)% · \(pace)"
    }
}

/// The editor itself.
///
/// The same four controls as `AddDrinkSheet`, and deliberately not the other
/// two. There is no time, because a favourite is not an event. There is no
/// stomach state, because one picked here would be a claim about every evening
/// afterwards, and it is the input that moves the slope of the rising limb
/// (2.) — the quick add takes it from the previous drink instead.
///
/// There is also no projected peak. The sheet's projection answers "where would
/// this take me tonight", and tonight is not what is being edited here.
struct FavouriteDrinkSheet: View {
    let store: SessionStore

    @Environment(\.dismiss) private var dismiss

    @State private var template: DrinkTemplate
    @State private var volumeMl: Double
    @State private var abv: Double
    @State private var drinkingMinutes: Double

    init(store: SessionStore) {
        self.store = store

        let existing = store.favourite ?? .suggestion
        _template = State(initialValue: existing.template)
        _volumeMl = State(initialValue: existing.volumeMl)
        _abv = State(initialValue: existing.abvPercent)
        _drinkingMinutes = State(initialValue: existing.drinkingMinutes)
    }

    private var draft: FavouriteDrink {
        FavouriteDrink(
            templateID: template.id,
            volumeMl: volumeMl,
            abvPercent: abv,
            drinkingMinutes: drinkingMinutes
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    DrinkTypePicker(template: $template) { item in
                        volumeMl = item.defaultVolumeMl
                        abv = item.defaultAbv
                        drinkingMinutes = item.defaultDrinkingMinutes
                    }
                    DrinkVolumeControl(template: template, volumeMl: $volumeMl)
                    DrinkStrengthControl(template: template, abv: $abv, volumeMl: volumeMl)
                    DrinkPaceControl(drinkingMinutes: $drinkingMinutes)

                    if store.favourite != nil {
                        removeButton
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .background(Theme.background)
            .scrollIndicators(.hidden)
            .navigationTitle(Text("Quick add"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.secondaryText)
                }
            }
            .safeAreaInset(edge: .bottom) { saveBar }
        }
        .preferredColorScheme(.dark)
    }

    private var saveBar: some View {
        Button {
            store.favourite = draft
            dismiss()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Save")
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(Theme.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Theme.calm, in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.hairline).frame(height: 1)
        }
    }

    /// Turns the button off entirely rather than hiding it behind a switch.
    /// The numbers stay on the person, so choosing a favourite again starts
    /// from what was last set rather than from the template defaults.
    private var removeButton: some View {
        Button(role: .destructive) {
            store.favourite = nil
            dismiss()
        } label: {
            Text("Remove favourite")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.elevated)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

#Preview {
    FavouriteDrinkSheet(store: .preview)
}
