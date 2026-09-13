import SwiftUI
import BACKit

/// Body composition, metabolism and the personal limit.
///
/// Its own tab rather than a sheet: this is where the iCloud switch, data
/// export and deletion will land, and a sheet does not have room to grow.
///
/// The elimination rate deliberately does not appear as a raw number: no user
/// can answer "what is your beta in per mille per hour", and a value set at
/// random makes the estimate worse. We ask about drinking frequency instead —
/// something everyone knows about themselves — and the raw parameters live
/// under advanced settings.
struct ProfileView: View {
    let store: SessionStore
    @State private var showsAdvanced = false

    var body: some View {
        NavigationStack {
            Form {
                bodySection
                metabolismSection
                limitSection
                unitSection
                derivedSection
                advancedSection
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle(Text("Profile"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: Body

    private var bodySection: some View {
        Section {
            Picker(selection: Binding(
                get: { store.profile.sex },
                set: { store.profile.sex = $0 }
            )) {
                Text("Male").tag(Sex.male)
                Text("Female").tag(Sex.female)
            } label: {
                Text("Sex")
            }
            .pickerStyle(.segmented)

            stepperRow(
                title: "Weight",
                value: Binding(get: { store.profile.weightKg }, set: { store.profile.weightKg = $0 }),
                range: 35...200, step: 1, unit: "kg"
            )

            stepperRow(
                title: "Height",
                value: Binding(get: { store.profile.heightCm }, set: { store.profile.heightCm = $0 }),
                range: 130...220, step: 1, unit: "cm"
            )

            stepperRow(
                title: "Age",
                value: Binding(get: { store.profile.age }, set: { store.profile.age = $0 }),
                range: 18...100, step: 1, unit: "yrs"
            )
        } header: {
            Text("Body")
        } footer: {
            // The Watson equation for women does not include age. Without
            // saying so, the unmoving value looks like a bug.
            if store.profile.sex == .female {
                Text("Total body water comes from the Watson equations, which set the volume alcohol distributes into. The female equation does not include age, so changing it will not affect the result.")
            } else {
                Text("Total body water comes from the Watson equations, which set the volume alcohol distributes into.")
            }
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Metabolism

    private var metabolismSection: some View {
        Section {
            Picker(selection: Binding(
                get: { store.frequency },
                set: { store.frequency = $0 }
            )) {
                ForEach(DrinkingFrequency.allCases) { option in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(option.label)
                        Text(option.detail)
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .tag(option)
                }
            } label: {
                Text("Drinking frequency")
            }
            .pickerStyle(.inline)
            .labelsHidden()
        } header: {
            Text("How often do you drink?")
        } footer: {
            Text("This is how we estimate your elimination rate. Regular drinking induces the liver's CYP2E1 pathway, so frequent drinkers clear alcohol faster. This is the weakest point of the model — which is why the app shows a range instead of a single number.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Personal limit

    private var limitSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Your limit")
                    Spacer()
                    Text(verbatim: store.unit.formatted(store.limit))
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.tint(for: store.limit))
                }
                Slider(
                    value: Binding(get: { store.limit }, set: { store.limit = $0 }),
                    in: 0.2...2.0, step: 0.05
                )
                .tint(Theme.tint(for: store.limit))
                .accessibilityLabel(Text("Your limit"))
            }
        } header: {
            Text("Your limit")
        } footer: {
            Text("Your own reference number, not a legal limit. The app tells you when a planned drink would take you past it, and for how long you would stay above.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Unit

    private var unitSection: some View {
        Section {
            Picker(selection: Binding(
                get: { store.unit },
                set: { store.unit = $0 }
            )) {
                ForEach(BACUnit.allCases) { unit in
                    HStack(spacing: 5) {
                        Text(unit.label)
                        Text(verbatim: "(\(unit.suffix))")
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .tag(unit)
                }
            } label: {
                Text("Unit")
            }
            .pickerStyle(.inline)
            .labelsHidden()
        } header: {
            Text("Display")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Derived values

    private var derivedSection: some View {
        Section {
            derived("Total body water", "\(store.profile.totalBodyWater.formatted(.number.precision(.fractionLength(1)))) L")
            derived("Distribution volume", "\(store.profile.distributionVolume.formatted(.number.precision(.fractionLength(1)))) L")
            derived("Widmark factor", store.profile.widmarkFactor.formatted(.number.precision(.fractionLength(3))))
        } header: {
            Text("Calculated values")
        } footer: {
            Text("The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far from that, it is worth checking the values above.")
        }
        .listRowBackground(Theme.surface)
    }

    private func derived(_ title: LocalizedStringKey, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Theme.secondaryText)
            Spacer()
            Text(verbatim: value)
                .font(.system(.body, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
    }

    // MARK: Advanced

    private var advancedSection: some View {
        Section {
            DisclosureGroup(isExpanded: $showsAdvanced) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Elimination rate")
                        Spacer()
                        Text(verbatim: store.unit.formatted(store.profile.beta) + "/h")
                            .font(.system(.body, design: .rounded).monospacedDigit())
                            .foregroundStyle(Theme.calm)
                    }
                    Slider(
                        value: Binding(get: { store.profile.beta }, set: { store.profile.beta = $0 }),
                        in: 0.10...0.25, step: 0.005
                    )
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("Elimination rate"))
                }
                .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Uncertainty")
                        Spacer()
                        Text(verbatim: "± " + store.unit.formatted(store.profile.betaUncertainty))
                            .font(.system(.body, design: .rounded).monospacedDigit())
                            .foregroundStyle(Theme.calm)
                    }
                    Slider(
                        value: Binding(
                            get: { store.profile.betaUncertainty },
                            set: { store.profile.betaUncertainty = $0 }
                        ),
                        in: 0.005...0.06, step: 0.005
                    )
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("Uncertainty"))
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Range")
                        .foregroundStyle(Theme.secondaryText)
                    Spacer()
                    Text(verbatim: store.unit.formatRange(store.profile.betaRange) + " /h")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                }
            } label: {
                Text("Advanced")
            }
        } footer: {
            Text("Only set these by hand if you have something to calibrate against — for example an actual breathalyser reading you can compare the estimate to.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Helpers

    private func stepperRow(
        title: LocalizedStringKey,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        unit: LocalizedStringKey
    ) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack {
                Text(title)
                Spacer()
                HStack(spacing: 3) {
                    Text(verbatim: value.wrappedValue.formatted(.number.precision(.fractionLength(0))))
                    Text(unit)
                }
                .font(.system(.body, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.calm)
            }
        }
    }
}

#Preview {
    ProfileView(store: .preview)
}
