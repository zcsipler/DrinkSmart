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

    /// The simulation is not cheap — six RK4 runs — and the body reads this
    /// from nine places. `SessionStore.project` keeps the last answer, so the
    /// repeats are a comparison of eight drinks rather than six simulations.
    ///
    /// It used to be cached here instead, in a `@State` filled by `onAppear`,
    /// with a direct call as the fallback while it was still nil. That fallback
    /// was the whole first render: every one of those nine reads ran the
    /// projection, the sheet took seconds to appear, and the cache it was
    /// meant to protect only arrived afterwards. A cache that the caller can
    /// silently miss is the wrong place for one.
    private var projection: BandedProjection {
        store.project(candidate, excluding: editing?.id, in: session)
    }

    /// The limit the projection is judged against — a past session's own, not
    /// today's, for the same reason its profile snapshot is used.
    private var limit: Double { session?.limit ?? store.limit }

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
                    setDefaultButton
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

                BACReadout(projection.peakRange, unit: store.unit, limit: limit, size: 22)
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
        case .above: Theme.alarm
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

    // MARK: Drink type, amount, strength
    //
    // The controls themselves live in `DrinkControls`, because the favourite
    // editor needs the same four and a second copy would drift.

    private var typePicker: some View {
        DrinkTypePicker(template: $template) { item in
            volumeMl = item.defaultVolumeMl
            abv = item.defaultAbv
            drinkingMinutes = item.defaultDrinkingMinutes
        }
    }

    private var volumeSection: some View {
        DrinkVolumeControl(template: template, volumeMl: $volumeMl)
    }

    private var abvSection: some View {
        DrinkStrengthControl(template: template, abv: $abv, volumeMl: volumeMl)
    }

    // MARK: Stomach state

    private var stomachSection: some View {
        ControlSection("Stomach") {
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

    private var paceSection: some View {
        DrinkPaceControl(drinkingMinutes: $drinkingMinutes)
    }

    // MARK: Time

    private var timeSection: some View {
        ControlSection("When", trailing: showsTimePicker ? nil : consumedAt.hourMinute) {
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

    // MARK: The usual one
    //
    // Here rather than only in the profile, because this is where the answer is
    // already typed in. Someone who has just dialled in a 400 ml at 4.5 % has
    // described their usual drink; asking them to go and do it again in a
    // settings screen is how a feature ends up unused.
    //
    // It writes immediately and does not wait for Add: setting what you usually
    // drink and logging one are separate acts, and an edit of a drink from last
    // Tuesday is a perfectly good moment to do the first without the second.
    //
    // Only the four fields a favourite carries. The time and the stomach state
    // belong to this drink, not to the habit (see `FavouriteDrink`).

    private var draftFavourite: FavouriteDrink {
        FavouriteDrink(
            templateID: template.id,
            volumeMl: volumeMl,
            abvPercent: abv,
            drinkingMinutes: drinkingMinutes
        )
    }

    private var isFavourite: Bool { store.favourite == draftFavourite }

    private var setDefaultButton: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) { store.favourite = draftFavourite }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isFavourite ? "star.fill" : "star")
                    .font(.system(size: 13))
                if isFavourite {
                    Text("This is your quick-add drink")
                } else {
                    Text("Set as my quick-add drink")
                }
                Spacer()
            }
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundStyle(isFavourite ? Theme.secondaryText : Theme.calm)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isFavourite)
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
                .background(Theme.tint(for: projection.peakRange.upperBound, limit: limit), in: Capsule())
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
