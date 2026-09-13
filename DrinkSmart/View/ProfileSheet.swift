import SwiftUI
import BACKit

/// Testalkat, anyagcsere és a saját határ beállítása.
///
/// A lebontási sebesség szándékosan nem nyers számként jelenik meg: arra a
/// kérdésre, hogy „hány ‰/óra a bétád", egy felhasználó sem tud válaszolni,
/// és a találomra állított érték rontja a becslést. Helyette a fogyasztás
/// gyakoriságát kérdezzük — amit mindenki tud magáról —, a nyers paraméterek
/// pedig a haladó beállítások közé kerültek.
struct ProfileSheet: View {
    let store: SessionStore
    @Environment(\.dismiss) private var dismiss
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
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kész") { dismiss() }
                        .foregroundStyle(Theme.calm)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Testalkat

    private var bodySection: some View {
        Section {
            Picker("Nem", selection: Binding(
                get: { store.profile.sex },
                set: { store.profile.sex = $0 }
            )) {
                Text("Férfi").tag(Sex.male)
                Text("Nő").tag(Sex.female)
            }
            .pickerStyle(.segmented)

            stepperRow(
                title: "Testsúly",
                value: Binding(get: { store.profile.weightKg }, set: { store.profile.weightKg = $0 }),
                range: 35...200, step: 1, format: "%.0f kg"
            )

            stepperRow(
                title: "Magasság",
                value: Binding(get: { store.profile.heightCm }, set: { store.profile.heightCm = $0 }),
                range: 130...220, step: 1, format: "%.0f cm"
            )

            stepperRow(
                title: "Életkor",
                value: Binding(get: { store.profile.age }, set: { store.profile.age = $0 }),
                range: 18...100, step: 1, format: "%.0f év"
            )
        } header: {
            Text("Testalkat")
        } footer: {
            Text("Ebből számoljuk a teljes testvizet a Watson-formulával, ami az alkohol eloszlási terét adja meg.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Anyagcsere

    private var metabolismSection: some View {
        Section {
            Picker("Fogyasztás gyakorisága", selection: Binding(
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
            }
            .pickerStyle(.inline)
            .labelsHidden()
        } header: {
            Text("Milyen gyakran iszol?")
        } footer: {
            Text("Ebből becsüljük a lebontási sebességet. A rendszeres fogyasztás indukálja a máj CYP2E1 útvonalát, ezért a gyakori fogyasztók gyorsabban bontják le az alkoholt. Ez a modell leggyengébb pontja — ezért mutat az app tartományt egyetlen szám helyett.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Haladó

    private var advancedSection: some View {
        Section {
            DisclosureGroup(isExpanded: $showsAdvanced) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Lebontási sebesség")
                        Spacer()
                        Text(store.unit.formatted(store.profile.beta) + "/óra")
                            .font(.system(.body, design: .rounded).monospacedDigit())
                            .foregroundStyle(Theme.calm)
                    }
                    Slider(
                        value: Binding(get: { store.profile.beta }, set: { store.profile.beta = $0 }),
                        in: 0.10...0.25, step: 0.005
                    )
                    .tint(Theme.calm)
                }
                .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Bizonytalanság")
                        Spacer()
                        Text("± " + store.unit.formatted(store.profile.betaUncertainty))
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
                }
                .padding(.vertical, 4)

                HStack {
                    Text("Sáv")
                        .foregroundStyle(Theme.secondaryText)
                    Spacer()
                    Text(store.unit.formatRange(store.profile.betaRange) + "/óra")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                }
            } label: {
                Text("Haladó beállítások")
            }
        } footer: {
            Text("Csak akkor állítsd kézzel, ha van mihez igazítanod — például ha valaha alkoholszondával visszamérted magad, és tudod, mennyire tért el a becslés.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Saját határ

    private var limitSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Saját határ")
                    Spacer()
                    Text(store.unit.formatted(store.limit))
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.tint(for: store.limit))
                }
                Slider(
                    value: Binding(get: { store.limit }, set: { store.limit = $0 }),
                    in: 0.2...2.0, step: 0.05
                )
                .tint(Theme.tint(for: store.limit))
            }
        } header: {
            Text("Saját határ")
        } footer: {
            Text("A te referenciaszámod, nem jogi limit. Az app jelzi, ha egy tervezett ital átvinne rajta — és azt is, mennyi ideig maradnál fölötte.")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Mértékegység

    private var unitSection: some View {
        Section {
            Picker("Mértékegység", selection: Binding(
                get: { store.unit },
                set: { store.unit = $0 }
            )) {
                ForEach(BACUnit.allCases) { unit in
                    Text(unit.label).tag(unit)
                }
            }
            .pickerStyle(.inline)
            .labelsHidden()
        } header: {
            Text("Megjelenítés")
        }
        .listRowBackground(Theme.surface)
    }

    // MARK: Származtatott értékek

    private var derivedSection: some View {
        Section {
            derived("Teljes testvíz", "\(store.profile.totalBodyWater.formatted(.number.precision(.fractionLength(1)))) L")
            derived("Eloszlási térfogat", "\(store.profile.distributionVolume.formatted(.number.precision(.fractionLength(1)))) L")
            derived("Widmark-faktor", store.profile.widmarkFactor.formatted(.number.precision(.fractionLength(3))))
        } header: {
            Text("Számított értékek")
        } footer: {
            Text("A Widmark-faktor tipikusan 0,68 körül van férfiaknál és 0,55 körül nőknél. Ha a tiéd messze esik ettől, érdemes ellenőrizni a megadott adatokat.")
        }
        .listRowBackground(Theme.surface)
    }

    private func derived(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Theme.secondaryText)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
    }

    // MARK: Segéd

    private func stepperRow(
        title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        format: String
    ) -> some View {
        Stepper(value: value, in: range, step: step) {
            HStack {
                Text(title)
                Spacer()
                Text(String(format: format, value.wrappedValue))
                    .font(.system(.body, design: .rounded).monospacedDigit())
                    .foregroundStyle(Theme.calm)
            }
        }
    }
}

#Preview {
    ProfileSheet(store: .preview)
}
