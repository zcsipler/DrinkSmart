import SwiftUI
import SwiftData
import BACKit

/// The past, at three distances — the last seven days, a month, a year —
/// and as a whole, on the trend.
///
/// One screen, not a list and a separate statistics page. A segment picker
/// sets how much calendar is on screen, chevrons page it back and forth, the
/// chart shows one bar per day (or per month), and the sessions of that span
/// sit underneath as rows — tapping one opens its curve, drawn with that
/// session's own profile snapshot (5.5). Tapping a bar shows its value; the
/// segment only ever changes from the picker.
///
/// The trend segment is different in kind: no pages, no rows, the whole
/// recorded span on two scrolling, pinch-zoomable curves (`HistoryTrend`),
/// with the figures card covering everything ever recorded.
///
/// The free window is the first page of the week view: the last seven
/// drinking days, today included. Everything behind it — older pages, the
/// month and year views, and the reading on rows older than seven days — is
/// shown blurred with a lock, so a free user sees what is there and not just
/// that something is. `FeatureFlags.canShowHistory` is the one rule; the data
/// underneath is recorded for everyone.
struct HistoryView: View {
    let store: SessionStore

    /// Every session, the running one included: today's bar should count the
    /// drinks in your hand, not only the evenings that have already closed.
    /// The list below keeps to finished ones — the open session is Live's.
    @Query(sort: \DrinkingSession.startedAt, order: .reverse)
    private var allSessions: [DrinkingSession]

    @State private var segment: HistorySegment = .week
    @State private var offset = 0

    /// The trend's zoom and scroll, shared by its two cards.
    @State private var visibleDays = 90
    @State private var scrollX: Date = .distantPast
    @State private var showsPaywall = false
    @State private var showsJump = false

    private var flags: FeatureFlags { .shared }

    /// Filtered in memory for the same reason as in `LiveView`: a `@Query`
    /// predicate is fixed at view creation, and the person can change
    /// underneath it.
    private var sessions: [DrinkingSession] {
        let personID = store.person.id
        return allSessions.filter { $0.personID == personID }
    }

    /// Everything the screen derives, built once per body evaluation. The
    /// aggregate walks every day since records began; cheap, but not something
    /// to redo in each subview that needs a number from it.
    private struct Snapshot {
        let days: [DayBucket]
        /// The paged window, or nil on the trend segment.
        let window: HistoryWindow?
        let trend: HistoryTrend?
        let oldestOffset: Int
        let sessionsInWindow: [DrinkingSession]
        let isLocked: Bool

        /// The first day we were keeping records — the aggregate's own
        /// start, not the stored date: an evening logged before the stored
        /// date moves the start back (5.7), and every label must say the
        /// same thing the shading shows.
        let recordsBegan: Date?

        var figures: HistoryFigures { window?.figures ?? HistoryFigures(days: days) }
    }

    private var snapshot: Snapshot {
        let now = store.now
        let sessions = self.sessions
        let days = HistoryAggregate.days(
            from: sessions.map(\.historyOccasion),
            trackingStartedAt: store.person.trackingStartedAt,
            now: now
        )
        let recordsBegan = days.first { $0.state != .unknown }?.day.calendarDate

        guard let range = segment.range else {
            // The trend spans everything, so it is never inside the free
            // window; the one rule (`canShowHistory`) says so on its own.
            return Snapshot(
                days: days,
                window: nil,
                trend: HistoryTrend.make(days: days, halfLife: HistoryTrend.halfLife(forVisibleDays: visibleDays)),
                oldestOffset: 0,
                sessionsInWindow: [],
                isLocked: !flags.historyTrends,
                recordsBegan: recordsBegan
            )
        }

        let window = HistoryWindow.make(range: range, offset: offset, days: days, now: now)
        let inWindow = sessions.filter { session in
            guard session.endedAt != nil else { return false }
            let filedUnder = DrinkingDay.containing(session.startedAt).calendarDate
            return filedUnder >= window.interval.start && filedUnder < window.interval.end
        }
        return Snapshot(
            days: days,
            window: window,
            trend: nil,
            oldestOffset: HistoryWindow.oldestOffset(for: range, days: days, now: now),
            sessionsInWindow: inWindow,
            isLocked: !flags.historyTrends && !window.isWithinFreeWindow(at: now),
            recordsBegan: recordsBegan
        )
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            let snapshot = self.snapshot

            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    segmentPicker
                        .padding(.horizontal, 20)
                        .padding(.top, 6)
                        .padding(.bottom, 10)

                    ScrollView {
                        VStack(spacing: 14) {
                            header(snapshot)

                            VStack(spacing: 14) {
                                figures(snapshot)
                                if let trend = snapshot.trend {
                                    trendCard(trend, metric: .amount)
                                    trendCard(trend, metric: .peak)
                                } else {
                                    chartCard(snapshot, metric: .amount)
                                    chartCard(snapshot, metric: .peak)
                                }
                            }
                            .blur(radius: snapshot.isLocked ? 6 : 0)
                            .allowsHitTesting(!snapshot.isLocked)
                            .overlay {
                                if snapshot.isLocked { lockOverlay }
                            }

                            list(snapshot)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle(Text("History"))
            .navigationBarTitleDisplayMode(.inline)
            // Whose history this is has to be visible here too, or the list
            // silently becomes somebody else's.
            .toolbar {
                if flags.multiPerson {
                    ToolbarItem(placement: .topBarTrailing) {
                        PersonSwitcher(store: store)
                    }
                }
            }
            .sheet(isPresented: $showsPaywall) { HistoryPaywallSheet() }
            .sheet(isPresented: $showsJump) {
                if let range = segment.range, let window = snapshot.window {
                    HistoryJumpSheet(
                        range: range,
                        current: window.interval.start,
                        recordsBegan: snapshot.days.first?.day.calendarDate ?? store.person.trackingStartedAt,
                        now: store.now
                    ) { date in
                        offset = HistoryWindow.offset(containing: date, range: range, now: store.now)
                    }
                }
            }
            .onAppear { resetTrendZoom(days: snapshot.days) }
        }
    }

    // MARK: Segments and paging

    /// Changing the segment goes back to the newest page: the offsets of the
    /// three ranges do not mean the same thing, so a week offset carried into
    /// the month view would land on an arbitrary month. Entering the trend
    /// starts it at the newest end, at the zoom that fits what is recorded.
    private var segmentPicker: some View {
        Picker(selection: Binding(
            get: { segment },
            set: { newSegment in
                segment = newSegment
                offset = 0
                if newSegment == .trend { resetTrendZoom(days: snapshot.days) }
            }
        )) {
            ForEach(HistorySegment.offered) { segment in
                Text(segment.title).tag(segment)
            }
        } label: {
            Text("History")
        }
        .pickerStyle(.segmented)
    }

    /// The whole span if it fits a quarter, else the last quarter — enough
    /// to see a shape, not so much that a week is a pixel.
    private func resetTrendZoom(days: [DayBucket]) {
        let recorded = days.filter { $0.state != .unknown }.count
        visibleDays = min(90, max(HistoryTrendChartView.minimumVisibleDays, recorded))
        scrollX = Calendar.current.startOfDay(for: store.now)
            .addingTimeInterval(Double(1 - visibleDays) * 86_400)
    }

    @ViewBuilder
    private func header(_ snapshot: Snapshot) -> some View {
        if let window = snapshot.window {
            windowHeader(window, oldestOffset: snapshot.oldestOffset)
        } else {
            // No pages to step through: the span is simply named.
            Text(verbatim: spanTitle(recordsBegan: snapshot.recordsBegan))
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
                .frame(height: 30)
        }
    }

    private func spanTitle(recordsBegan: Date?) -> String {
        guard let recordsBegan else { return "" }
        return (recordsBegan..<store.now).formatted(date: .abbreviated, time: .omitted)
    }

    private func windowHeader(_ window: HistoryWindow, oldestOffset: Int) -> some View {
        HStack {
            pageButton(systemName: "chevron.left", enabled: offset < oldestOffset) {
                offset += 1
            }

            Spacer()

            // The title is a button: tap to jump anywhere. The chevrons stay
            // for the page next door — both, because reaching for a picker to
            // go back one week is as wrong as paging thirty-six months.
            Button {
                showsJump = true
            } label: {
                HStack(spacing: 5) {
                    Text(verbatim: title(for: window))
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.primaryText)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Theme.secondaryText)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            pageButton(systemName: "chevron.right", enabled: offset > 0) {
                offset -= 1
            }
        }
    }

    private func pageButton(systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .frame(width: 34, height: 30)
                .background(Theme.surface, in: RoundedRectangle(cornerRadius: 9))
        }
        .buttonStyle(.plain)
        .foregroundStyle(enabled ? Theme.primaryText : Theme.secondaryText.opacity(0.35))
        .disabled(!enabled)
    }

    /// The span on screen, in the user's calendar. The week's end is its last
    /// day, not the 05:00 boundary after it — that would print tomorrow.
    private func title(for window: HistoryWindow) -> String {
        switch window.range {
        case .week:
            guard
                let first = window.bars.first?.interval.start,
                let last = window.bars.last?.interval.start
            else { return "" }
            return (first..<last).formatted(date: .abbreviated, time: .omitted)
        case .month:
            return window.interval.start.formatted(.dateTime.month(.wide).year())
        case .year:
            return window.interval.start.formatted(.dateTime.year())
        }
    }

    // MARK: Figures

    /// Four figures for the window — or for everything, on the trend — then,
    /// when there is one, the change against the window before it, with that
    /// window named underneath: "+239 %" on its own reads as an accusation;
    /// "vs. Sep 8–14" makes it a comparison.
    private func figures(_ snapshot: Snapshot) -> some View {
        let window = snapshot.figures
        return VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 0) {
                stat(store.amountUnit.shortLabel, store.amountUnit.format(standardUnits: window.totalUnits))
                divider
                stat("Drinks", window.drinkCount.formatted())
                divider
                soberDays(window)
                divider
                peak(window)
            }

            // No row at all when there is nothing to compare against — the
            // first recorded window, or one after a quiet one. A "—" would
            // only raise the question the row is there to answer.
            if let change = window.unitsChange, let paged = snapshot.window {
                Divider().overlay(Theme.hairline).padding(.horizontal, 14)

                VStack(spacing: 4) {
                    Text("Change")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .textCase(.uppercase)
                        .foregroundStyle(Theme.secondaryText)
                    Text(verbatim: change.formatted(.percent.precision(.fractionLength(0)).sign(strategy: .always())))
                        .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.primaryText)
                    (Text("vs.") + Text(verbatim: " \(previousTitle(for: paged))"))
                        .font(.system(size: 9, design: .rounded))
                        .foregroundStyle(Theme.secondaryText.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    /// The highest level in the window, coloured against the limit that day.
    /// The peak chart below shows the same thing bar by bar; this is the one
    /// number you can read without tapping anything.
    private func peak(_ window: HistoryFigures) -> some View {
        VStack(spacing: 4) {
            Text("peak")
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            if let peak = window.peakRange, let limit = window.limit {
                Text(verbatim: store.unit.formatRange(peak))
                    .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                    .foregroundStyle(Theme.tint(for: peak.midpoint, limit: limit))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } else {
                Text(verbatim: "—")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
    }

    /// The window before this one, named the way the header names this one.
    private func previousTitle(for window: HistoryWindow) -> String {
        let previous = HistoryWindow.interval(for: window.range, offset: window.offset + 1, now: store.now)
        switch window.range {
        case .week:
            let calendar = Calendar.current
            let lastDay = calendar.date(byAdding: .day, value: -1, to: previous.end) ?? previous.end
            return (previous.start..<lastDay).formatted(date: .abbreviated, time: .omitted)
        case .month:
            return previous.start.formatted(.dateTime.month(.wide).year())
        case .year:
            return previous.start.formatted(.dateTime.year())
        }
    }

    /// Sober days out of the days we were keeping records. When the window
    /// reaches back before records began, the denominator is smaller than
    /// the calendar — "4 / 9" in a year view needs a reason, and the reason
    /// is printed under it. It disappears on its own once a full window has
    /// been recorded.
    private func soberDays(_ window: HistoryFigures) -> some View {
        VStack(spacing: 4) {
            Text("Sober days")
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: "\(window.dryDays.formatted()) / \(window.recordedDays.formatted())")
                .font(.system(size: 15, weight: .medium, design: .rounded).monospacedDigit())
                .foregroundStyle(Theme.primaryText)
            if window.unknownDays > 0 {
                (Text(verbatim: "\(window.unknownDays.formatted()) ") + Text("before records"))
                    .font(.system(size: 9, design: .rounded))
                    .foregroundStyle(Theme.secondaryText.opacity(0.8))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var divider: some View {
        Rectangle().fill(Theme.hairline).frame(width: 1, height: 26)
    }

    private func stat(_ title: LocalizedStringResource, _ value: String) -> some View {
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

    // MARK: Chart

    /// Two of these, one under the other: how much, then how high. The legend
    /// for the shaded pre-record days sits under the second only — it applies
    /// to both, and saying it twice would read as two different things.
    @ViewBuilder
    private func chartCard(_ snapshot: Snapshot, metric: HistoryChartView.Metric) -> some View {
        if let window = snapshot.window {
            VStack(alignment: .leading, spacing: 10) {
                HistoryChartView(
                    window: window,
                    metric: metric,
                    amountUnit: store.amountUnit,
                    unit: store.unit,
                    recordsBegan: snapshot.recordsBegan ?? store.person.trackingStartedAt
                )

                if metric == .peak {
                    legend(window)
                }
            }
            .padding(14)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: Trend

    /// The caption names the smoothing, because a curve that changes shape
    /// when you pinch needs to say why: the amount is averaged over days,
    /// the peak over evenings out — the same number, counted in what each
    /// curve knows about (`HistoryTrend`).
    private func trendCard(_ trend: HistoryTrend, metric: HistoryTrendChartView.Metric) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HistoryTrendChartView(
                trend: trend,
                metric: metric,
                amountUnit: store.amountUnit,
                unit: store.unit,
                limit: store.limit,
                now: store.now,
                visibleDays: $visibleDays,
                scrollX: $scrollX
            )

            HStack(spacing: 4) {
                Text("Smoothing")
                Text(verbatim: "·")
                switch metric {
                case .amount:
                    Text(verbatim: Duration.seconds(trend.halfLife * 86_400)
                        .formatted(.units(allowed: [.days], width: .wide)))
                case .peak:
                    Text("\(trend.halfLife.formatted()) sessions")
                }
            }
            .font(.system(size: 10, design: .rounded))
            .foregroundStyle(Theme.secondaryText)
        }
        .padding(14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    /// Only when there is something to explain: the shaded days before
    /// records began. Bars and their colours are the chart itself.
    @ViewBuilder
    private func legend(_ window: HistoryWindow) -> some View {
        if window.unknownDays > 0 {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.surfaceRaised.opacity(0.45))
                    .frame(width: 16, height: 9)
                Text("before records")
            }
            .font(.system(size: 10, design: .rounded))
            .foregroundStyle(Theme.secondaryText)
        }
    }

    // MARK: Lock

    private var lockOverlay: some View {
        Button {
            showsPaywall = true
        } label: {
            VStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 22, weight: .medium))
                Text("See further back")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(Theme.primaryText)
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            .background(Theme.surfaceRaised.opacity(0.92), in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    // MARK: List

    @ViewBuilder
    private func list(_ snapshot: Snapshot) -> some View {
        if snapshot.sessionsInWindow.isEmpty {
            if sessions.isEmpty { emptyState }
        } else {
            LazyVStack(spacing: 10) {
                ForEach(snapshot.sessionsInWindow) { session in
                    let locked = !flags.canShowHistory(
                        for: DrinkingDay.containing(session.startedAt), at: store.now
                    )
                    if locked {
                        Button {
                            showsPaywall = true
                        } label: {
                            SessionRow(session: session, unit: store.unit, locked: true)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink {
                            SessionDetailView(session: session, store: store)
                        } label: {
                            SessionRow(session: session, unit: store.unit)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 26, weight: .light))
                .foregroundStyle(Theme.secondaryText.opacity(0.6))
            Text("No past sessions yet")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.primaryText)
            Text("A session appears here once it has ended — when your level has cleared and a few hours have passed.")
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 30)
    }
}

#Preview {
    HistoryView(store: .preview)
}
