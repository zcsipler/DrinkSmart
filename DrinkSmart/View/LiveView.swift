import SwiftUI
import SwiftData
import BACKit

/// The running session — and, by swiping, the days before it.
///
/// Paging lives here rather than only in History because the most common
/// question is not "show me March", it is "what did last night look like".
///
/// The swipe is deliberately **not** active on the curve itself: the chart
/// already owns horizontal dragging for reading values off it, and two
/// competing horizontal gestures on one surface cannot both win. It is applied
/// block by block to everything around the chart, with `simultaneousGesture`
/// so the enclosing `ScrollView` does not swallow it first.
struct LiveView: View {
    let store: SessionStore

    /// Changes every time the user asks for this tab. See `MainTabView`.
    let homeToken: Int

    /// 0 is the current drinking day, −1 yesterday, and so on. Never positive:
    /// there is nothing to see in the future. There is no lower bound —
    /// paging past the start of tracking is allowed, it just says so.
    @State private var dayOffset = 0

    @State private var showsAddDrink = false
    @State private var editingDrink: Drink?
    @State private var openRowID: UUID?

    /// Live translation of the paging drag, for the follow-the-finger offset.
    @State private var dragTranslation: CGFloat = 0

    /// All finished sessions. The volume is small — a heavy year is a few
    /// hundred rows — so filtering by day in memory beats rebuilding a
    /// predicate every time the offset changes.
    @Query(
        filter: #Predicate<DrinkingSession> { $0.endedAt != nil },
        sort: \DrinkingSession.startedAt,
        order: .reverse
    )
    private var finishedSessions: [DrinkingSession]

    /// Ticks every half minute — this does not change the band, only where
    /// on it we read.
    private let clock = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    // MARK: What this day is

    /// What the day has to show. Four cases, and the last two are genuinely
    /// different: an empty day we were recording is evidence, an empty day
    /// before we started recording is only ignorance.
    private enum DayState {
        case live
        case recorded([DrinkingSession])
        case dry
        case untracked
    }

    private var day: DrinkingDay {
        DrinkingDay.containing(store.now).offset(by: dayOffset)
    }

    private var isCurrentDay: Bool { dayOffset == 0 }

    private var sessionsOfDay: [DrinkingSession] {
        finishedSessions
            .filter { day.contains($0.startedAt) }
            .sorted { $0.startedAt < $1.startedAt }
    }

    private var dayState: DayState {
        if isCurrentDay, !store.drinks.isEmpty { return .live }
        if !sessionsOfDay.isEmpty { return .recorded(sessionsOfDay) }
        // Entirely before we kept records: we do not know, and must not guess.
        if day.end <= store.settings.trackingStartedAt { return .untracked }
        return .dry
    }

    // MARK: Body

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                dayHeader
                content
            }

            if isCurrentDay {
                VStack {
                    Spacer()
                    addButton
                }
            }
        }
        .onReceive(clock) { _ in store.tick() }
        .sheet(isPresented: $showsAddDrink) { AddDrinkSheet(store: store) }
        .sheet(item: $editingDrink) { drink in
            AddDrinkSheet(store: store, editing: drink, session: sessionOwning(drink))
        }
        .onChange(of: store.drinks.count) { openRowID = nil }
        .onChange(of: editingDrink?.id) { openRowID = nil }
        .onChange(of: dayOffset) { openRowID = nil }
        // Asking for this tab means asking for now, not for whichever day was
        // left on screen last time.
        .onChange(of: homeToken) {
            guard dayOffset != 0 else { return }
            withAnimation(.easeInOut(duration: 0.25)) { dayOffset = 0 }
        }
    }

    /// Which session a drink belongs to — nil means the running one.
    private func sessionOwning(_ drink: Drink) -> DrinkingSession? {
        sessionsOfDay.first { session in
            (session.drinks ?? []).contains { $0.id == drink.id }
        }
    }

    // MARK: Day header

    private var dayHeader: some View {
        HStack {
            stepButton(systemName: "chevron.left", step: -1, enabled: true)

            Spacer()

            Text(verbatim: dayTitle)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(isCurrentDay ? Theme.secondaryText : Theme.primaryText)
                .contentTransition(.opacity)

            Spacer()

            stepButton(systemName: "chevron.right", step: 1, enabled: !isCurrentDay)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 10)
        .animation(.easeInOut(duration: 0.2), value: dayOffset)
        .simultaneousGesture(pagingGesture)
    }

    /// The chevrons are real buttons, not decoration.
    ///
    /// A gesture nobody discovers is a feature nobody has, and a tap target is
    /// also the only way this works with VoiceOver or Switch Control.
    private func stepButton(systemName: String, step: Int, enabled: Bool) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) { page(by: step) }
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.secondaryText.opacity(enabled ? 0.7 : 0.15))
                .frame(width: 44, height: 34)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(step < 0 ? Text("Previous day") : Text("Next day"))
    }

    private var dayTitle: String {
        switch day.daysAgo(from: store.now) {
        case 0: String(localized: "Today")
        case 1: String(localized: "Yesterday")
        default: day.calendarDate.formatted(.dateTime.weekday(.wide).month().day())
        }
    }

    // MARK: Content

    private var content: some View {
        ScrollView {
            VStack(spacing: 26) {
                switch dayState {
                case .live:
                    liveSession
                case .recorded(let sessions):
                    ForEach(sessions) { session in
                        SessionContentView(
                            session: session,
                            store: store,
                            editingDrink: $editingDrink,
                            openRowID: $openRowID,
                            showsProfileNote: false
                        )
                        .simultaneousGesture(pagingGesture)
                    }
                case .dry:
                    emptyState(
                        icon: "face.smiling",
                        tint: Theme.calm,
                        title: isCurrentDay ? "Nothing logged today" : "You didn't drink on this day",
                        detail: isCurrentDay
                            ? "Add a drink when you have one, or swipe to look back at earlier days."
                            : "Nothing was logged between 5 in the morning and the next."
                    )
                case .untracked:
                    emptyState(
                        icon: "face.dashed",
                        tint: Theme.secondaryText,
                        title: "No data for this day",
                        detail: "This is before the app started keeping records, so there is nothing to say about it either way."
                    )
                }

                if isCurrentDay {
                    disclaimer.simultaneousGesture(pagingGesture)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, isCurrentDay ? 100 : 30)
            // Follows the finger a little, so the swipe feels attached to the
            // content rather than being a hidden command.
            .offset(x: dragTranslation * 0.35)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private var liveSession: some View {
        hero.simultaneousGesture(pagingGesture)
        BACChartView(model: store.chartModel)
        liveStatRow.simultaneousGesture(pagingGesture)
        DrinkListSection(
            drinks: store.drinks,
            openRowID: $openRowID,
            onEdit: { editingDrink = $0 },
            onDelete: { drink in withAnimation { store.remove(drink) } }
        )
        .simultaneousGesture(pagingGesture)
    }

    // MARK: Hero

    private var hero: some View {
        VStack(spacing: 6) {
            HStack {
                Spacer()
                Button { store.clearSession() } label: {
                    Text("End session")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.secondaryText)
                }
            }
            .frame(height: 20)

            BACReadout(store.currentRange, unit: store.unit, size: 48)

            (store.currentRange.isPoint ? Text("estimated level") : Text("estimated range"))
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
        }
    }

    private var liveStatRow: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                stat("Elapsed", store.sessionDuration.compactDuration)
                divider
                stat("Drinks", store.drinks.count.formatted())
                divider
                stat("Units", store.totalUnits.formatted(.number.precision(.fractionLength(1))))
            }

            if let sober = store.soberRange {
                Divider().overlay(Theme.hairline).padding(.horizontal, 14)

                VStack(spacing: 3) {
                    Text("Expected to clear")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .textCase(.uppercase)
                        .foregroundStyle(Theme.secondaryText)
                    Text(verbatim: sober.hourMinuteRange)
                        .font(.system(size: 17, weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                }
            }
        }
        .padding(.vertical, 14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    private var divider: some View {
        Rectangle().fill(Theme.hairline).frame(width: 1, height: 26)
    }

    private func stat(_ title: LocalizedStringKey, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: value)
                .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Empty days
    //
    // A day with nothing on it is not an error state. For an app about
    // drinking less it is the good outcome — so it says so plainly, without
    // congratulating anyone for an ordinary Tuesday. And a day we have no
    // records for says only that, because we genuinely do not know.

    private func emptyState(
        icon: String,
        tint: Color,
        title: LocalizedStringKey,
        detail: LocalizedStringKey
    ) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 42, weight: .thin))
                .foregroundStyle(tint.opacity(0.75))

            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
                .multilineTextAlignment(.center)

            Text(detail)
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 54)
        .background(Theme.surface.opacity(0.5), in: RoundedRectangle(cornerRadius: 18))
        .padding(.top, 40)
        .contentShape(Rectangle())
        .simultaneousGesture(pagingGesture)
    }

    // MARK: Disclaimer

    private var disclaimer: some View {
        VStack(spacing: 6) {
            Text("This is an estimate, not a measurement.")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
            Text("Actual values vary considerably between individuals. Never use this to decide whether you can drive.")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Theme.secondaryText.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 10)
    }

    // MARK: Add button
    //
    // Floats above the tab bar rather than moving into the navigation bar:
    // logging a drink is the app's most frequent action, and it happens
    // one-handed in a bar. Thumb reach beats tidiness here.

    private var addButton: some View {
        Button { showsAddDrink = true } label: {
            HStack(spacing: 9) {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
                Text("Add drink")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(Theme.background)
            .padding(.horizontal, 26)
            .padding(.vertical, 15)
            .background(Theme.calm, in: Capsule())
            .shadow(color: Theme.background.opacity(0.7), radius: 16, y: 6)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 12)
    }

    // MARK: Paging

    private func page(by step: Int) {
        dayOffset = min(dayOffset + step, 0)
    }

    private var pagingGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { value in
                // Ignore mostly-vertical drags so scrolling still works.
                guard abs(value.translation.width) > abs(value.translation.height) else { return }

                // Resist dragging towards the future, where there is nothing.
                let raw = value.translation.width
                dragTranslation = (isCurrentDay && raw > 0) ? raw * 0.25 : raw
            }
            .onEnded { value in
                defer { withAnimation(.easeOut(duration: 0.2)) { dragTranslation = 0 } }
                guard abs(value.translation.width) > abs(value.translation.height) else { return }

                let travelled = value.predictedEndTranslation.width
                guard abs(travelled) > 70 else { return }

                withAnimation(.easeInOut(duration: 0.25)) {
                    // Right-to-left goes back in time, as asked. This is the
                    // opposite of the usual paging convention, so it is written
                    // down rather than left to be rediscovered.
                    page(by: travelled < 0 ? -1 : 1)
                }
            }
    }
}

#Preview {
    LiveView(store: .preview, homeToken: 0)
}
