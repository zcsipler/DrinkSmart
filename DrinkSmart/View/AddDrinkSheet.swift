import SwiftUI
import BACKit

/// Ital felvitele — és ami ennél fontosabb: az élő előrejelzés arról,
/// hová vinné ez a görbét.
///
/// A döntés a kiöntés előtt születik, ezért a vetített csúcs itt jelenik meg,
/// nem utólag a főképernyőn.
struct AddDrinkSheet: View {
    let store: SessionStore
    @Environment(\.dismiss) private var dismiss

    @State private var template = DrinkCatalog.all[0]
    @State private var volumeMl: Double = 500
    @State private var abv: Double = 5
    @State private var stomach: StomachState = .light
    @State private var consumedAt: Date = .now
    @State private var showsTimePicker = false

    /// Stabil azonosító, hogy a csúszka mozgatása ne gyártson minden
    /// képfrissítésnél új itallal egyenértékű objektumot.
    @State private var draftID = UUID()

    /// A szimuláció nem olcsó, ezért nem a `body`-ban fut, hanem a bemenet
    /// változásakor egyszer.
    @State private var cachedProjection: BandedProjection?

    private var projection: BandedProjection {
        cachedProjection ?? store.project(candidate)
    }

    /// A vetítés bemenete. Csak akkor számolunk újra, ha ez változik.
    private struct Input: Equatable {
        var templateID: String
        var volumeMl: Double
        var abv: Double
        var stomach: StomachState
        var consumedAt: Date
    }

    private var input: Input {
        Input(templateID: template.id, volumeMl: volumeMl, abv: abv, stomach: stomach, consumedAt: consumedAt)
    }

    private var candidate: Drink {
        Drink(
            id: draftID,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            abvPercent: abv,
            stomach: stomach,
            name: template.name
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    projectionCard
                    typePicker
                    volumeSection
                    abvSection
                    stomachSection
                    timeSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            }
            .background(Theme.background)
            .scrollIndicators(.hidden)
            .navigationTitle("Ital hozzáadása")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Mégse") { dismiss() }
                        .foregroundStyle(Theme.secondaryText)
                }
            }
            .safeAreaInset(edge: .bottom) { confirmBar }
        }
        .preferredColorScheme(.dark)
        .onAppear { recalculate() }
        .onChange(of: input) { recalculate() }
    }

    private func recalculate() {
        cachedProjection = store.project(candidate)
    }

    // MARK: Előrejelzés

    private var projectionCard: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 0) {
                projectionColumn(
                    title: "Most",
                    value: store.unit.formatRange(projection.currentRange),
                    tint: Theme.tint(for: projection.currentRange.upperBound)
                )

                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 18)

                projectionColumn(
                    title: "Vetített csúcs",
                    value: store.unit.formatRange(projection.peakRange),
                    tint: Theme.tint(for: projection.peakRange.upperBound)
                )
            }

            Divider().overlay(Theme.hairline)

            HStack(spacing: 0) {
                detail("Csúcs ekkor", projection.peakDate.hourMinute + " körül")
                detail("Csúcsig", projection.timeToPeak.compactDuration)
                detail("Kiürül", projection.soberRange?.hourMinuteRange ?? "—")
            }

            if projection.outcome.exceedsPossible {
                limitWarning
            }
        }
        .padding(18)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(projection.outcome == .below ? Theme.hairline : outcomeTint.opacity(0.5), lineWidth: 1)
        }
        .animation(.easeOut(duration: 0.18), value: projection.peakRange.upperBound)
    }

    private var outcomeTint: Color {
        switch projection.outcome {
        case .below: Theme.calm
        case .uncertain: Theme.caution
        case .above: Theme.elevated
        }
    }

    private func projectionColumn(title: String, value: String, tint: Color) -> some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.sectionLabel)
                .foregroundStyle(Theme.secondaryText)
            Text(value)
                .font(.readout(30))
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity)
    }

    private func detail(_ title: String, _ value: String) -> some View {
        VStack(spacing: 3) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity)
    }

    /// Háromállapotú figyelmeztetés.
    ///
    /// A bizonytalanság miatt van egy köztes eset, amit tisztességtelen lenne
    /// bármelyik irányba kerekíteni: a lassú lebontás átvinne a határon, a
    /// gyors nem. Ilyenkor „átlépheted" a helyes állítás, nem „átlépnéd".
    private var limitWarning: some View {
        HStack(spacing: 8) {
            Image(systemName: projection.outcome == .above
                  ? "exclamationmark.triangle.fill"
                  : "questionmark.circle.fill")
                .font(.system(size: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(projection.outcome == .above
                     ? "Átlépnéd a saját határod"
                     : "Átlépheted a saját határod")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))

                Text(projection.outcome == .above
                     ? detailAbove
                     : "A lassabb lebontás esetén igen, a gyorsabbnál nem. Ez a becslés bizonytalansága.")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(outcomeTint.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .foregroundStyle(outcomeTint)
        .padding(12)
        .background(outcomeTint.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    }

    private var detailAbove: String {
        guard let crossed = projection.limitCrossedAt else {
            return "Legfeljebb \(projection.maxTimeAboveLimit.compactDuration) hosszan maradnál fölötte."
        }
        return "\(crossed.hourMinute) körül, legfeljebb \(projection.maxTimeAboveLimit.compactDuration) hosszan."
    }

    // MARK: Italtípus

    private var typePicker: some View {
        section("Típus") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(DrinkCatalog.all) { item in
                    Button {
                        withAnimation(.easeOut(duration: 0.15)) { select(item) }
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: item.icon)
                                .font(.system(size: 18))
                            Text(item.name)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
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

    private func select(_ item: DrinkTemplate) {
        template = item
        volumeMl = item.defaultVolumeMl
        abv = item.defaultAbv
    }

    // MARK: Térfogat

    private var volumeSection: some View {
        section("Mennyiség", trailing: "\(Int(volumeMl)) ml") {
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    ForEach(template.volumeOptions, id: \.self) { option in
                        Button {
                            withAnimation(.easeOut(duration: 0.15)) { volumeMl = option }
                        } label: {
                            Text("\(Int(option))")
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
            }
        }
    }

    // MARK: Alkoholfok

    private var abvSection: some View {
        section("Alkoholfok", trailing: abv.formatted(.number.precision(.fractionLength(1))) + " %") {
            VStack(spacing: 6) {
                Slider(value: $abv, in: template.abvRange, step: 0.5)
                    .tint(Theme.calm)

                HStack {
                    Text("\(candidate.standardUnits.formatted(.number.precision(.fractionLength(1)))) egység")
                    Spacer()
                    Text("\(candidate.gramsEthanol.formatted(.number.precision(.fractionLength(0)))) g alkohol")
                }
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            }
        }
    }

    // MARK: Gyomorállapot

    private var stomachSection: some View {
        section("Gyomor") {
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    ForEach(StomachState.allCases, id: \.self) { state in
                        Button {
                            withAnimation(.easeOut(duration: 0.15)) { stomach = state }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: state.icon)
                                    .font(.system(size: 15))
                                Text(state.shortLabel)
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                stomach == state ? Theme.calm.opacity(0.18) : Theme.surface,
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(stomach == state ? Theme.calm : Theme.hairline, lineWidth: 1)
                            }
                            .foregroundStyle(stomach == state ? Theme.calm : Theme.primaryText)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text(stomach.explanation)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
                    .id(stomach)
            }
        }
    }

    // MARK: Időpont

    private var timeSection: some View {
        section("Időpont", trailing: showsTimePicker ? nil : consumedAt.hourMinute) {
            VStack(spacing: 10) {
                if showsTimePicker {
                    DatePicker("", selection: $consumedAt, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                } else {
                    HStack(spacing: 8) {
                        quickTime("Most", minutesAgo: 0)
                        quickTime("15 perce", minutesAgo: 15)
                        quickTime("30 perce", minutesAgo: 30)
                        quickTime("1 órája", minutesAgo: 60)
                    }
                }

                Button(showsTimePicker ? "Kész" : "Pontos idő megadása") {
                    withAnimation(.easeInOut(duration: 0.2)) { showsTimePicker.toggle() }
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.calm)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func quickTime(_ label: String, minutesAgo: Int) -> some View {
        let target = Date.now.addingTimeInterval(-Double(minutesAgo) * 60)
        let isSelected = abs(consumedAt.timeIntervalSince(target)) < 60

        return Button {
            withAnimation(.easeOut(duration: 0.15)) { consumedAt = target }
        } label: {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
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

    // MARK: Megerősítés

    private var confirmBar: some View {
        Button {
            store.add(candidate)
            dismiss()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Hozzáadás")
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(Theme.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Theme.tint(for: projection.peakRange.upperBound), in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }

    // MARK: Szekció-keret

    private func section<Content: View>(
        _ title: String,
        trailing: String? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title.uppercased())
                    .font(.sectionLabel)
                    .foregroundStyle(Theme.secondaryText)
                Spacer()
                if let trailing {
                    Text(trailing)
                        .font(.system(size: 12, weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                }
            }
            content()
        }
    }
}

#Preview {
    AddDrinkSheet(store: .preview)
}
