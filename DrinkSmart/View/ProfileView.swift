import SwiftUI
import BACKit

/// Body composition, metabolism and the personal limit.
///
/// Its own tab rather than a sheet: backup and restore live here too
/// (`DataTransferSection`), deletion will follow, and a sheet does not have
/// room to grow.
///
/// The elimination rate deliberately does not appear as a raw number: no user
/// can answer "what is your beta in per mille per hour", and a value set at
/// random makes the estimate worse. We ask about drinking frequency instead —
/// something everyone knows about themselves.
///
/// The raw rate is still reachable, and the block that holds it explains how
/// someone could actually arrive at their own figure — from a breathalyser, or
/// from watching whether they clear earlier than the app predicts. But it sits
/// folded away at the very bottom of the advanced section, below everything
/// else, because a control placed any higher reads as a question the user is
/// expected to answer, and most of them cannot.
struct ProfileView: View {
    let store: SessionStore
    @State private var showsAdvanced = false

    private var flags: FeatureFlags { .shared }

    var body: some View {
        NavigationStack {
            Form {
                bodySection
                metabolismSection
                limitSection
                unitSection
                derivedSection
                advancedSection
                DataTransferSection(store: store)
                #if DEBUG
                developerSection
                #endif
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle(Text("Profile"))
            .navigationBarTitleDisplayMode(.inline)
            // These fields edit the *selected* person's body. Without the chip
            // there would be nothing on screen saying whose.
            .toolbar {
                if flags.multiPerson {
                    ToolbarItem(placement: .topBarTrailing) {
                        PersonSwitcher(store: store)
                    }
                }
            }
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
            Text("This is how we estimate your elimination rate. Regular drinking induces the liver's CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the model, which is why you can set under Advanced how much of that uncertainty the app shows you.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Personal limit

    private var limitSection: some View {
        Section {
            LimitSlider(store: store)
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
                UncertaintyControl(store: store)
                EliminationRateGroup(store: store)
            } label: {
                Text("Advanced")
            }
        } footer: {
            Text("Uncertainty is a matter of taste: it decides whether figures read as one number or as a range. The rate below is not — leave it to the frequency question unless you have a measurement to match it against.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Developer
    //
    // Debug builds only, and deliberately at the very bottom, below Advanced:
    // these switches change what the app *is*, not how it calculates. The
    // strings here are not localized — the only reader is the developer.

    #if DEBUG
    private var developerSection: some View {
        Section {
            ForEach(Feature.allCases) { feature in
                Toggle(isOn: Binding(
                    get: { flags.isEnabled(feature) },
                    set: { flags.setOverride($0, for: feature) }
                )) {
                    Text(feature.title)
                }
                .tint(Theme.calm)
            }
        } header: {
            Text(verbatim: "Developer")
        } footer: {
            Text(verbatim: "Feature flags. Off in release builds until a purchase unlocks them; this switch only exists in debug.")
        }
        .listRowBackground(Theme.surface)
    }
    #endif

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

// MARK: - Sliders
//
// Each slider is its own view, and each keeps the value it is being dragged to
// in local state until the finger lifts.
//
// Two reasons, and both are measured or evident rather than assumed. Writing to
// the store on every step boundary makes `AppSettings` re-encode itself into
// UserDefaults, and for the profile it also re-runs `simulateBand` — three RK4
// integrations, 2.5–6 ms depending on how many drinks are in the session, which
// is a large part of a 120 Hz frame. On top of that, a value read from the
// store invalidates whoever read it: with these controls inlined in
// `ProfileView` that was the whole `Form`, six sections including the
// elimination explainer's eight interpolated, localized strings.
//
// Holding the draft locally means a drag re-renders one row and touches
// nothing else. The store is written once, on release. Anything that has to
// move *with* the value therefore lives inside the row that owns the draft —
// which is why the explainer moved here with its slider rather than staying
// behind in `ProfileView`.

/// The personal limit.
private struct LimitSlider: View {
    let store: SessionStore

    /// Non-nil only while a drag is in progress.
    @State private var draft: Double?

    private var value: Double { draft ?? store.limit }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Your limit")
                Spacer()
                Text(verbatim: store.unit.formatted(value))
                    .font(.system(.body, design: .rounded).monospacedDigit())
                    // Always the alarm colour, and it means something literal:
                    // this is the number the readout turns red on. Tinting it
                    // by its own level would be circular — the ramp is a
                    // fraction of the limit, so a limit is always exactly 1.
                    .foregroundStyle(Theme.alarm)
            }
            Slider(
                value: Binding(get: { value }, set: { draft = $0 }),
                in: 0.2...2.0,
                step: 0.05,
                onEditingChanged: { editing in
                    guard !editing, let draft else { return }
                    store.limit = draft
                    self.draft = nil
                }
            )
            .tint(Theme.calm)
            .accessibilityLabel(Text("Your limit"))
        }
    }
}

/// How wide the band is — and therefore whether figures read as points or
/// as ranges.
///
/// Zero by default (see `Physiology.defaultBetaUncertainty`), but the
/// control is a real one: above zero the app stops asserting a point and
/// reports the spread instead, which is the more literal reading of what
/// the model knows.
private struct UncertaintyControl: View {
    let store: SessionStore

    @State private var draft: Double?

    private var value: Double { draft ?? store.profile.betaUncertainty }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Uncertainty")
                Spacer()
                Text(verbatim: "± " + store.unit.formatted(value))
                    .font(.system(.body, design: .rounded).monospacedDigit())
                    .foregroundStyle(Theme.calm)
            }
            Slider(
                value: Binding(get: { value }, set: { draft = $0 }),
                in: 0...0.06,
                step: 0.005,
                onEditingChanged: { editing in
                    guard !editing, let draft else { return }
                    store.profile.betaUncertainty = draft
                    self.draft = nil
                }
            )
            .tint(Theme.calm)
            .accessibilityLabel(Text("Uncertainty"))

            VStack(alignment: .leading, spacing: 6) {
                Text("At zero every figure is a single number — the app's best estimate. Above zero the same figures are shown as ranges, and the band on the chart widens to match.")

                Text("A single number is easier to learn against: over time you find out what your own 0.6 feels like. A range is the more literal answer, because the rate really is uncertain. Both are defensible — this is your call.")

                Text("The spread suggested by your drinking frequency is ± \(store.unit.formatted(store.frequency.uncertainty)) per hour.")
                    .foregroundStyle(Theme.calm)
            }
            .font(.system(size: 12, design: .rounded))
            .foregroundStyle(Theme.secondaryText)
        }
        .padding(.vertical, 4)
    }
}

/// The elimination rate, one level deeper still.
///
/// Nobody knows their own beta, and nothing in daily life would ever
/// prompt someone to say "my clearance is 0.18 per hour". The drinking
/// frequency question above already sets it. It stays reachable for
/// calibration against a breathalyser, but at the very bottom of the
/// deepest section and folded away, so it is not offered as a choice.
private struct EliminationRateGroup: View {
    let store: SessionStore

    @State private var draft: Double?

    private var value: Double { draft ?? store.profile.beta }

    /// The band that follows from the draft, so the range below the slider
    /// tracks the drag instead of jumping on release.
    private var betaRange: ClosedRange<Double> {
        var preview = store.profile
        preview.beta = value
        return preview.betaRange
    }

    var body: some View {
        DisclosureGroup {
            explainer

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Rate")
                        .foregroundStyle(Theme.secondaryText)
                    Spacer()
                    Text(verbatim: store.unit.formatted(value) + "/h")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.calm)
                }
                Slider(
                    value: Binding(get: { value }, set: { draft = $0 }),
                    in: 0.10...0.25,
                    step: 0.005,
                    onEditingChanged: { editing in
                        guard !editing, let draft else { return }
                        store.profile.beta = draft
                        self.draft = nil
                    }
                )
                .tint(Theme.calm)
                .accessibilityLabel(Text("Elimination rate"))
            }
            .padding(.vertical, 4)

            HStack {
                Text("Range")
                    .foregroundStyle(Theme.secondaryText)
                Spacer()
                Text(verbatim: store.unit.formatRange(betaRange) + " /h")
                    .font(.system(.body, design: .rounded).monospacedDigit())
                    .foregroundStyle(Theme.primaryText)
            }
        } label: {
            HStack {
                Text("Elimination rate")
                Spacer()
                Text(verbatim: store.unit.formatted(value) + "/h")
                    .font(.system(.footnote, design: .rounded).monospacedDigit())
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .padding(.vertical, 2)
    }

    /// What the elimination rate actually is.
    ///
    /// Without this the slider is a number nobody can reason about. The live
    /// clearing example is the part that makes it concrete — an abstract
    /// "0.15 per hour" means nothing until you see it as hours of your evening.
    /// It reads the draft, so it still moves under the finger.
    private var explainer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How fast your liver clears alcohol once it has been absorbed — the slope of the falling side of the curve.")

            Text("Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the enzyme that breaks it down already runs at full capacity at almost any level. That is why rules of thumb like “one drink an hour” exist at all.")

            Text("At this setting, \(store.unit.formatted(1.0)) takes about \(clearingTimeFromOne) to clear. Almost everyone falls between \(store.unit.formatRange(0.10...0.25)) per hour.")
                .foregroundStyle(Theme.calm)

            Text("How to find yours")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.primaryText)
                .padding(.top, 2)

            tip(
                "With a breathalyser",
                "Blow twice, at least an hour apart, on the falling side — two hours or more after your last drink, with nothing in between. Subtract the second reading from the first and divide by the hours between them."
            )

            Text("For example \(store.unit.formatted(0.70)) and \(store.unit.formatted(0.42)) two hours later works out to \(store.unit.formatted(0.14)) per hour.")
                .foregroundStyle(Theme.calm)
                .padding(.leading, 2)

            tip(
                "Without one",
                "The app tells you when it expects you to clear. If you are reliably back to normal well before that, your rate is higher than the setting — nudge it up a step and watch for a few sessions. If it takes longer than predicted, nudge it down."
            )

            tip(
                "What moves it",
                "Regular drinking raises it: the liver enzyme that does the work is induced by use. It also runs slightly higher in women on average, and lower on an empty stomach or with liver trouble."
            )
        }
        .font(.system(size: 12, design: .rounded))
        .foregroundStyle(Theme.secondaryText)
        .padding(.vertical, 6)
    }

    private func tip(_ title: LocalizedStringKey, _ body: LocalizedStringKey) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText.opacity(0.8))
            Text(body)
        }
        .padding(.top, 2)
    }

    /// How long 1 g/L would take to clear at the current rate. Deliberately
    /// ignores absorption: this is about the descending limb only.
    private var clearingTimeFromOne: String {
        let hours = 1.0 / max(value, 0.01)
        return (hours * 3600).compactDuration
    }
}

#Preview {
    ProfileView(store: .preview)
}
