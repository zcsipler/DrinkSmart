import SwiftUI
import BACKit

/// Who is being recorded, and the way to change it.
///
/// A chip rather than a tab or a sheet: switching has to be reachable in one
/// tap in a bar, and it has to be *visible* everywhere, because the app is
/// recording someone else's evening until it is changed back. It took the
/// corner where "End session" used to sit — see `SessionPolicy` for why that
/// button is gone rather than moved.
struct PersonSwitcher: View {
    let store: SessionStore

    @State private var showsAddPerson = false

    var body: some View {
        Menu {
            ForEach(store.people) { candidate in
                Button {
                    store.activate(candidate)
                } label: {
                    if candidate.id == store.person.id {
                        Label { name(of: candidate) } icon: { Image(systemName: "checkmark") }
                    } else {
                        name(of: candidate)
                    }
                }
            }

            Divider()

            Button {
                showsAddPerson = true
            } label: {
                Label { Text("Add person") } icon: { Image(systemName: "person.badge.plus") }
            }
        } label: {
            chip
        }
        .accessibilityLabel(Text("Switch person"))
        .sheet(isPresented: $showsAddPerson) {
            AddPersonSheet(store: store)
        }
    }

    @ViewBuilder
    private func name(of person: Person) -> some View {
        if let displayName = person.displayName {
            Text(verbatim: displayName)
        } else {
            Text("You")
        }
    }

    private var chip: some View {
        HStack(spacing: 6) {
            Text(verbatim: store.person.monogram)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.background)
                .frame(width: 16, height: 16)
                .background(Theme.accent(for: store.person.accent), in: Circle())

            name(of: store.person)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)

            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Theme.secondaryText)
        }
        .padding(.leading, 4)
        .padding(.trailing, 9)
        .padding(.vertical, 4)
        .background(Theme.surface, in: Capsule())
        .overlay(Capsule().strokeBorder(Theme.hairline))
    }
}

/// Everything the model needs about someone, and nothing else.
///
/// The body questions are not optional and not defaulted away: the curve is a
/// function of sex, age, height and weight, so a guest entered with half of
/// them would get a confidently drawn wrong answer. The limit and the drinking
/// frequency *are* defaulted, because both are adjustable later and neither
/// changes the shape of the curve the way the body does.
struct AddPersonSheet: View {
    let store: SessionStore

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var sex: Sex = .female
    @State private var weightKg: Double = 65
    @State private var heightCm: Double = 168
    @State private var age: Double = 30
    @State private var frequency: DrinkingFrequency = .occasional

    /// A person with no name is indistinguishable from the owner in the menu.
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(text: $name) { Text("Name") }
                        .textInputAutocapitalization(.words)
                }
                .listRowBackground(Theme.surface)

                Section {
                    Picker(selection: $sex) {
                        Text("Male").tag(Sex.male)
                        Text("Female").tag(Sex.female)
                    } label: {
                        Text("Sex")
                    }
                    .pickerStyle(.segmented)

                    stepperRow(title: "Weight", value: $weightKg, range: 35...200, unit: "kg")
                    stepperRow(title: "Height", value: $heightCm, range: 130...220, unit: "cm")
                    stepperRow(title: "Age", value: $age, range: 18...100, unit: "yrs")
                } header: {
                    Text("Body")
                } footer: {
                    Text("All four change the curve, so none of them can be guessed for someone else.")
                }
                .listRowBackground(Theme.surface)

                Section {
                    Picker(selection: $frequency) {
                        ForEach(DrinkingFrequency.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    } label: {
                        Text("Drinking frequency")
                    }
                } footer: {
                    Text("Their own limit and the finer settings can be changed later on the Profile tab, while they are the selected person.")
                }
                .listRowBackground(Theme.surface)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle(Text("New person"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: { Text("Cancel") }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button { save() } label: { Text("Add") }
                        .disabled(!canSave)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func save() {
        var profile = BodyProfile(sex: sex, age: age, heightCm: heightCm, weightKg: weightKg)
        frequency.apply(to: &profile)

        store.addPerson(
            name: name.trimmingCharacters(in: .whitespaces),
            profile: profile,
            frequency: frequency,
            limit: 0.8
        )
        dismiss()
    }

    /// The same row as the Profile tab's, kept local: the two will diverge —
    /// that one edits a live person and writes on every step, this one fills a
    /// draft that does not exist yet.
    private func stepperRow(
        title: LocalizedStringKey,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        unit: LocalizedStringKey
    ) -> some View {
        Stepper(value: value, in: range, step: 1) {
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
    AddPersonSheet(store: .preview)
}
