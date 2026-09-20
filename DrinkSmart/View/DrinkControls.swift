import SwiftUI
import BACKit

/// The controls that describe a drink: type, amount, strength, pace.
///
/// Extracted from `AddDrinkSheet` when the favourite editor needed the same
/// four. Two copies would mean that adding a drink type, or widening a slider,
/// has to be remembered in two places — and the one that gets forgotten is the
/// one nobody is looking at.
///
/// Stomach state and time are deliberately **not** here. They describe a
/// particular drink at a particular moment, which is the one thing a standing
/// favourite is not (see `FavouriteDrink`).

/// The label-and-value chrome every control sits in.
struct ControlSection<Content: View>: View {
    let title: LocalizedStringKey
    let trailing: String?
    let content: Content

    init(
        _ title: LocalizedStringKey,
        trailing: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.trailing = trailing
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.sectionLabel)
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.secondaryText)
                Spacer()
                if let trailing {
                    Text(verbatim: trailing)
                        .font(.system(size: 12, weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                }
            }
            content
        }
    }
}

// MARK: - Type

struct DrinkTypePicker: View {
    @Binding var template: DrinkTemplate

    /// Picking a type replaces the values that belong to it. The caller owns
    /// them, so the caller applies them — this view does not reach into state
    /// it cannot see.
    let onSelect: (DrinkTemplate) -> Void

    var body: some View {
        ControlSection("Type") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(DrinkCatalog.all) { item in
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) {
                            template = item
                            onSelect(item)
                        }
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: item.icon)
                                .font(.system(size: 18))
                            Text(item.name)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            template.id == item.id ? Theme.calm.opacity(0.18) : Theme.surface,
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(template.id == item.id ? Theme.calm : Theme.hairline, lineWidth: 1)
                        }
                        .foregroundStyle(template.id == item.id ? Theme.calm : Theme.primaryText)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Amount

struct DrinkVolumeControl: View {
    let template: DrinkTemplate
    @Binding var volumeMl: Double

    var body: some View {
        ControlSection("Amount", trailing: "\(volumeMl.formatted(.number.precision(.fractionLength(0)))) ml") {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    ForEach(template.volumeOptions, id: \.self) { option in
                        Button {
                            withAnimation(.easeOut(duration: 0.15)) { volumeMl = option }
                        } label: {
                            Text(verbatim: option.formatted(.number.precision(.fractionLength(0))))
                                .font(.system(size: 13, weight: .medium, design: .rounded).monospacedDigit())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 9)
                                .background(
                                    abs(volumeMl - option) < 0.5 ? Theme.calm.opacity(0.18) : Theme.surface,
                                    in: RoundedRectangle(cornerRadius: 10)
                                )
                                .foregroundStyle(abs(volumeMl - option) < 0.5 ? Theme.calm : Theme.secondaryText)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Slider(value: $volumeMl, in: 10...1000, step: 10)
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("Amount"))
            }
        }
    }
}

// MARK: - Strength

struct DrinkStrengthControl: View {
    let template: DrinkTemplate
    @Binding var abv: Double

    /// Only to work out what the drink contains — the footer below the slider
    /// is the one place the two numbers become a quantity of alcohol.
    let volumeMl: Double

    private var grams: Double {
        volumeMl * (abv / 100) * Physiology.ethanolDensity
    }

    var body: some View {
        ControlSection("Strength", trailing: abv.formatted(.number.precision(.fractionLength(1))) + " %") {
            VStack(spacing: 6) {
                Slider(value: $abv, in: template.abvRange, step: 0.5)
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("Strength"))

                HStack {
                    Text("\((grams / Physiology.gramsPerStandardUnit).formatted(.number.precision(.fractionLength(1)))) units")
                    Spacer()
                    Text("\(grams.formatted(.number.precision(.fractionLength(0)))) g alcohol")
                }
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            }
        }
    }
}

// MARK: - Pace
//
// Across an evening this barely moves the peak, but it roughly halves the rate
// of rise — and that is the number memory impairment tracks. A shot thrown back
// and a pint nursed for half an hour are not the same event, even when the
// alcohol is identical.

struct DrinkPaceControl: View {
    @Binding var drinkingMinutes: Double

    var body: some View {
        ControlSection("How fast", trailing: paceLabel) {
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    preset("In one go", minutes: 0)
                    preset("15 min", minutes: 15)
                    preset("30 min", minutes: 30)
                    preset("1 hr", minutes: 60)
                }

                Slider(value: $drinkingMinutes, in: 0...180, step: 5)
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("How fast"))

                Text(explanation)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var paceLabel: String {
        drinkingMinutes <= 0
            ? String(localized: "In one go")
            : (drinkingMinutes * 60).compactDuration
    }

    private var explanation: LocalizedStringResource {
        switch drinkingMinutes {
        case 0: "Counts as a single swallow — the steepest possible rise."
        case ..<20: "A quick drink. The level climbs fast."
        case ..<45: "A normal pace."
        default: "Nursed slowly. Much gentler climb for the same alcohol."
        }
    }

    private func preset(_ label: LocalizedStringKey, minutes: Double) -> some View {
        let isSelected = abs(drinkingMinutes - minutes) < 0.5

        return Button {
            withAnimation(.easeOut(duration: 0.15)) { drinkingMinutes = minutes }
        } label: {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(
                    isSelected ? Theme.calm.opacity(0.18) : Theme.surface,
                    in: RoundedRectangle(cornerRadius: 10)
                )
                .foregroundStyle(isSelected ? Theme.calm : Theme.secondaryText)
        }
        .buttonStyle(.plain)
    }
}
