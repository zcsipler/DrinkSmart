import SwiftUI
import SwiftData
import BACKit

/// The running session: today, and nothing else.
///
/// Looking back used to live here as a swipe between days, but a horizontal
/// drag had to share the screen with the chart's own drag and with the drink
/// rows' delete swipe, and it lost to both — it was there, it just took three
/// attempts to hit. Reaching a past evening is what History is for. Whether the
/// two get joined up again, and how, is an open question.
struct LiveView: View {
    let store: SessionStore

    @State private var showsAddDrink = false
    @State private var editingDrink: Drink?
    @State private var openRowID: UUID?

    /// The last quick add, while its correction strip is still up. Nil the rest
    /// of the time, which is nearly always.
    @State private var receipt: QuickAddReceipt?

    /// All finished sessions. The volume is small — a heavy year is a few
    /// hundred rows — so filtering by day in memory beats a predicate.
    @Query(
        filter: #Predicate<DrinkingSession> { $0.endedAt != nil },
        sort: \DrinkingSession.startedAt,
        order: .reverse
    )
    private var finishedSessions: [DrinkingSession]

    /// Ticks every half minute — this does not change the band, only where
    /// on it we read.
    private let clock = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    // MARK: What today is

    /// Three cases. A fourth, `untracked`, used to exist for days before the
    /// app kept records (see 5.7): today can never be one of those, so it lives
    /// on in the model and belongs in History, not here.
    private enum DayState {
        case live
        case recorded([DrinkingSession])
        case dry
    }

    /// The drinking day, which turns over at 5 in the morning, not at midnight.
    private var day: DrinkingDay {
        DrinkingDay.containing(store.now)
    }

    /// Sessions already closed today — an evening that started before 5 this
    /// morning and has since cleared still belongs to this day.
    ///
    /// Filtered by person here rather than in the `@Query` predicate: a query
    /// filter is fixed when the view is created, and the active person can
    /// change while this screen is on screen. The volume argument above applies
    /// to both filters equally.
    private var sessionsOfDay: [DrinkingSession] {
        let personID = store.person.id
        return finishedSessions
            .filter { $0.personID == personID && day.contains($0.startedAt) }
            .sorted { $0.startedAt < $1.startedAt }
    }

    private var dayState: DayState {
        if !store.drinks.isEmpty { return .live }
        if !sessionsOfDay.isEmpty { return .recorded(sessionsOfDay) }
        return .dry
    }

    // MARK: Body

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            content

            VStack(spacing: 0) {
                Spacer()

                if let receipt {
                    QuickAddStrip(
                        receipt: receipt,
                        onCorrect: { store.correct(receipt.drink, stomach: $0) },
                        onSetDefault: { store.makeFavourite(receipt.drink) },
                        onUndo: {
                            store.undoQuickAdd(receipt)
                            dismissStrip()
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                QuickAddBar(
                    store: store,
                    offer: store.quickAddOffer,
                    onQuickAdd: quickAdd,
                    onOpenSheet: { showsAddDrink = true }
                )
            }
        }
        .onReceive(clock) { _ in store.tick() }
        .sheet(isPresented: $showsAddDrink) { AddDrinkSheet(store: store) }
        .sheet(item: $editingDrink) { drink in
            AddDrinkSheet(store: store, editing: drink, session: sessionOwning(drink))
        }
        .onChange(of: store.drinks.count) { openRowID = nil }
        .onChange(of: editingDrink?.id) { openRowID = nil }
        // A quick add is silent by design, so the phone says what the screen
        // does not have to: the user is looking at a bar, not at this. Only on
        // the way in — the strip expiring is not an event worth a buzz, and a
        // plain `.success` trigger would fire for that too.
        .sensoryFeedback(trigger: receipt?.id) { _, new in
            new == nil ? nil : .success
        }
        // Keyed on the drink, so a second quick add restarts the countdown
        // rather than inheriting the remains of the first one's.
        .task(id: receipt?.id) {
            guard receipt != nil else { return }
            try? await Task.sleep(for: .seconds(Self.stripDuration))
            guard !Task.isCancelled else { return }
            dismissStrip()
        }
    }

    /// How long the correction strip stays up.
    ///
    /// Long enough to notice a mis-tap and read the drink's name, short enough
    /// that it is gone before the next round. It covers the list, and the list
    /// is what the screen is for.
    private static let stripDuration: Double = 6

    private func quickAdd() {
        guard let added = store.quickAdd() else { return }
        openRowID = nil
        withAnimation(.easeOut(duration: 0.22)) { receipt = added }
    }

    private func dismissStrip() {
        withAnimation(.easeOut(duration: 0.2)) { receipt = nil }
    }

    /// Which session a drink belongs to — nil means the running one.
    private func sessionOwning(_ drink: Drink) -> DrinkingSession? {
        sessionsOfDay.first { session in
            (session.drinks ?? []).contains { $0.id == drink.id }
        }
    }

    // MARK: Content

    private var content: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Above the day, not inside it: the most likely moment to add
                // someone is a day with nothing on it yet, and a switcher that
                // only appears once a session is running would be missing
                // exactly then.
                if FeatureFlags.shared.multiPerson {
                    HStack {
                        Spacer()
                        PersonSwitcher(store: store)
                    }
                }

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
                        }
                    case .dry:
                        emptyState
                    }

                    disclaimer
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private var liveSession: some View {
        hero
        BACChartView(model: store.chartModel)
        liveStatRow
        DrinkListSection(
            drinks: store.drinks,
            openRowID: $openRowID,
            onEdit: { editingDrink = $0 },
            onDelete: { drink in withAnimation { store.remove(drink) } }
        )
    }

    // MARK: Hero

    private var hero: some View {
        VStack(spacing: 6) {
            BACReadout(store.currentRange, unit: store.unit, limit: store.limit, size: 48)

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

    // MARK: A day with nothing on it
    //
    // Not an error state. For an app about drinking less it is the good
    // outcome — so it says so plainly, without congratulating anyone for an
    // ordinary Tuesday.

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "face.smiling")
                .font(.system(size: 42, weight: .thin))
                .foregroundStyle(Theme.calm.opacity(0.75))

            Text("Nothing logged today")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
                .multilineTextAlignment(.center)

            Text("Add a drink when you have one.")
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 54)
        .background(Theme.surface.opacity(0.5), in: RoundedRectangle(cornerRadius: 18))
        .padding(.top, 40)
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

    // The add controls live in `QuickAddBar`.
    //
    // They float above the tab bar rather than moving into the navigation bar:
    // logging a drink is the app's most frequent action, and it happens
    // one-handed in a bar. Thumb reach beats tidiness here — which is also why
    // the quick add did not become a long press on the same capsule. A hidden
    // gesture is not a shortcut.
}

#Preview {
    LiveView(store: .preview)
}
