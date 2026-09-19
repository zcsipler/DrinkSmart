import SwiftUI
import BACKit

/// Logging a drink — and, more importantly, the live projection of where it
/// would take the curve.
///
/// The decision is made before the drink is poured, so the projected peak
/// belongs here rather than on the main screen afterwards.
///
/// The same sheet corrects an already logged drink. Passing `editing` prefills
/// every control and switches the wording; the projection then compares the
/// session without that drink against the session with the corrected version.
struct AddDrinkSheet: View {
    let store: SessionStore

    /// Non-nil when correcting a drink that is already in the session.
    let editing: Drink?

    /// Which session the drink belongs to. Nil means the running one; the
    /// history detail passes a past session so the projection is made against
    /// that evening's own profile snapshot.
    let session: DrinkingSession?

    @Environment(\.dismiss) private var dismiss

    @State private var template: DrinkTemplate
    @State private var volumeMl: Double
    @State private var abv: Double
    @State private var stomach: StomachState
    @State private var drinkingMinutes: Double
    @State private var consumedAt: Date
    @State private var showsTimePicker = false

    /// A stable identifier, so that dragging a slider does not mint a new
    /// drink-equivalent object on every redraw. When editing, this is the
    /// existing drink's id, which is what lets `update(_:)` find it.
    @State private var draftID: UUID

    init(store: SessionStore, editing: Drink? = nil, session: DrinkingSession? = nil) {
        self.store = store
        self.editing = editing
        self.session = session

        let template = editing.map(DrinkCatalog.template(for:)) ?? DrinkCatalog.all[0]
        _template = State(initialValue: template)
        _volumeMl = State(initialValue: editing?.volumeMl ?? template.defaultVolumeMl)
        _abv = State(initialValue: editing?.abvPercent ?? template.defaultAbv)
        _stomach = State(initialValue: editing?.stomach ?? .light)
        _drinkingMinutes = State(
            initialValue: editing?.drinkingMinutes ?? template.defaultDrinkingMinutes
        )
        _consumedAt = State(initialValue: editing?.consumedAt ?? .now)
        _draftID = State(initialValue: editing?.id ?? UUID())
        // "15 min ago" is meaningless when correcting a drink from hours back,
        // so an edit opens straight on the exact-time picker.
        _showsTimePicker = State(initialValue: editing != nil)
    }

    private var isEditing: Bool { editing != nil }

    /// The simulation is not cheap, so it runs once when the input changes
    /// rather than inside `body`.
    @State private var cachedProjection: BandedProjection?

    private var projection: BandedProjection {
        cachedProjection ?? store.project(candidate, excluding: editing?.id, in: session)
    }

    /// Inputs to the projection. We only recompute when this changes.
    private struct Input: Equatable {
        var templateID: String
        var volumeMl: Double
        var abv: Double
        var stomach: StomachState
        var drinkingMinutes: Double
        var consumedAt: Date
    }

    private var input: Input {
        Input(
            templateID: template.id, volumeMl: volumeMl, abv: abv,
            stomach: stomach, drinkingMinutes: drinkingMinutes, consumedAt: consumedAt
        )
    }

    private var candidate: Drink {
        Drink(
            id: draftID,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            abvPercent: abv,
            stomach: stomach,
            drinkingMinutes: drinkingMinutes,
            name: template.id
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    typePicker
                    volumeSection
                    abvSection
                    stomachSection
                    paceSection
                    timeSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .background(Theme.background)
            .scrollIndicators(.hidden)
            .navigationTitle(isEditing ? Text("Edit drink") : Text("Add drink"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
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
        cachedProjection = store.project(candidate, excluding: editing?.id, in: session)
    }

    // MARK: Projection
    //
    // Lives above the Add button rather than at the top of the sheet. The
    // projected peak is not what you pick a drink by — you already know you
    // want a beer — so putting it first only pushed the type picker below the
    // fold. At the button it sits where the decision actually happens, and the
    // one part that earns its place before committing, the limit warning,
    // grows out of it when there is something to say.

    private var projectionSummary: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                Text(isEditing ? "With this" : "Projected peak")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundStyle(Theme.secondaryText)

                BACReadout(projection.peakRange, unit: store.unit, size: 22)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 3) {
                miniStat("Peak at", projection.peakDate.hourMinute)
                miniStat("Clears", projection.soberRange?.hourMinuteRange ?? "—")
            }
        }
        .animation(.easeOut(duration: 0.18), value: projection.peakRange.upperBound)
    }

    private func miniStat(_ title: LocalizedStringKey, _ value: String) -> some View {
        HStack(spacing: 5) {
            Text(title)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: value)
                .font(.system(size: 12, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
    }

    private var outcomeTint: Color {
        switch projection.outcome {
        case .below: Theme.calm
        case .uncertain: Theme.caution
        case .above: Theme.elevated
        }
    }

    /// Three-state warning.
    ///
    /// The uncertainty leaves a middle case that would be dishonest to round
    /// in either direction: slow elimination crosses the limit, fast does not.
    /// There "might cross" is the accurate claim, not "would cross".
    private var limitWarning: some View {
        HStack(spacing: 8) {
            Image(systemName: projection.outcome == .above
                  ? "exclamationmark.triangle.fill"
                  : "questionmark.circle.fill")
                .font(.system(size: 12))

            VStack(alignment: .leading, spacing: 2) {
                if projection.outcome == .above {
                    Text("This would cross your limit")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                    Text("Around \(crossingTime), for up to \(projection.maxTimeAboveLimit.compactDuration).")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundStyle(outcomeTint.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("This might cross your limit")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                    Text("With slower metabolism yes, with faster no. That's the uncertainty of the estimate.")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundStyle(outcomeTint.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
        }
        .foregroundStyle(outcomeTint)
        .padding(10)
        .background(outcomeTint.opacity(0.12), in: RoundedRectangle(cornerRadius: 11))
    }

    private var crossingTime: String {
        projection.limitCrossedAt?.hourMinute ?? candidate.consumedAt.hourMinute
    }

    // MARK: Drink type

    private var typePicker: some View {
        section("Type") {
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

    private func select(_ item: DrinkTemplate) {
        template = item
        volumeMl = item.defaultVolumeMl
        abv = item.defaultAbv
        drinkingMinutes = item.defaultDrinkingMinutes
    }

    // MARK: Volume

    private var volumeSection: some View {
        section("Amount", trailing: "\(volumeMl.formatted(.number.precision(.fractionLength(0)))) ml") {
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

    // MARK: Strength

    private var abvSection: some View {
        section("Strength", trailing: abv.formatted(.number.precision(.fractionLength(1))) + " %") {
            VStack(spacing: 6) {
                Slider(value: $abv, in: template.abvRange, step: 0.5)
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("Strength"))

                HStack {
                    Text("\(candidate.standardUnits.formatted(.number.precision(.fractionLength(1)))) units")
                    Spacer()
                    Text("\(candidate.gramsEthanol.formatted(.number.precision(.fractionLength(0)))) g alcohol")
                }
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            }
        }
    }

    // MARK: Stomach state

    private var stomachSection: some View {
        section("Stomach") {
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
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
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

    // MARK: Pace
    //
    // Across an evening this barely moves the peak, but it roughly halves the
    // rate of rise — and that is the number memory impairment tracks. A shot
    // thrown back and a pint nursed for half an hour are not the same event,
    // even when the alcohol is identical.

    private var paceSection: some View {
        section("How fast", trailing: paceLabel) {
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    pacePreset("In one go", minutes: 0)
                    pacePreset("15 min", minutes: 15)
                    pacePreset("30 min", minutes: 30)
                    pacePreset("1 hr", minutes: 60)
                }

                Slider(value: $drinkingMinutes, in: 0...180, step: 5)
                    .tint(Theme.calm)
                    .accessibilityLabel(Text("How fast"))

                Text(paceExplanation)
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

    private var paceExplanation: LocalizedStringResource {
        switch drinkingMinutes {
        case 0: "Counts as a single swallow — the steepest possible rise."
        case ..<20: "A quick drink. The level climbs fast."
        case ..<45: "A normal pace."
        default: "Nursed slowly. Much gentler climb for the same alcohol."
        }
    }

    private func pacePreset(_ label: LocalizedStringKey, minutes: Double) -> some View {
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

    // MARK: Time

    private var timeSection: some View {
        section("When", trailing: showsTimePicker ? nil : consumedAt.hourMinute) {
            VStack(spacing: 10) {
                if showsTimePicker {
                    // Date as well as time, so a drink can be filled in days
                    // or months later. The store routes it to the session
                    // covering that drinking day rather than to whichever one
                    // is open now.
                    DatePicker(
                        selection: $consumedAt,
                        in: ...Date.now,
                        displayedComponents: [.date, .hourAndMinute]
                    ) {
                        Text("When")
                    }
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(Theme.calm)
                } else {
                    HStack(spacing: 8) {
                        quickTime("Now", minutesAgo: 0)
                        quickTime("15 min ago", minutesAgo: 15)
                        quickTime("30 min ago", minutesAgo: 30)
                        quickTime("1 hr ago", minutesAgo: 60)
                    }
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { showsTimePicker.toggle() }
                } label: {
                    if showsTimePicker {
                        Text("Done")
                    } else {
                        Text("Set exact time")
                    }
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.calm)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func quickTime(_ label: LocalizedStringKey, minutesAgo: Int) -> some View {
        let target = Date.now.addingTimeInterval(-Double(minutesAgo) * 60)
        let isSelected = abs(consumedAt.timeIntervalSince(target)) < 60

        return Button {
            withAnimation(.easeOut(duration: 0.15)) { consumedAt = target }
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

    // MARK: Confirmation

    private var confirmBar: some View {
        VStack(spacing: 12) {
            if projection.outcome.exceedsPossible {
                limitWarning
            }

            projectionSummary

            Button {
                if isEditing {
                    store.update(candidate, in: session)
                } else {
                    store.add(candidate)
                }
                dismiss()
            } label: {
                HStack {
                    Image(systemName: isEditing ? "checkmark.circle.fill" : "plus.circle.fill")
                    if isEditing {
                        Text("Save changes")
                    } else {
                        Text("Add")
                    }
                }
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Theme.tint(for: projection.peakRange.upperBound), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.hairline).frame(height: 1)
        }
    }

    // MARK: Section chrome

    private func section<Content: View>(
        _ title: LocalizedStringKey,
        trailing: String? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
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
            content()
        }
    }
}

@MainActor
private struct EditSheetPreview: View {
    private let store = SessionStore.preview

    var body: some View {
        AddDrinkSheet(store: store, editing: store.drinks.last)
    }
}

#Preview("Add") {
    AddDrinkSheet(store: .preview)
}

#Preview("Edit") {
    EditSheetPreview()
}
