import SwiftUI
import Charts
import BACKit

/// The blood alcohol curve.
///
/// It draws a band, not a line. Across its plausible range the elimination
/// rate shifts the peak by over 40 % and the time to clear by hours — a single
/// line would claim a precision that is not there. The width of the band is
/// itself information: it shows how well we know what we are asserting.
///
/// What it deliberately does NOT show: a verdict. No "you can drive", no "safe".
///
/// Takes a `BACChartModel` rather than the store, so the same view renders a
/// past evening from the history with that session's own profile snapshot.
struct BACChartView: View {
    let model: BACChartModel

    /// The time selected while scrubbing.
    @State private var scrubDate: Date?

    private var band: BACBand { model.band }
    private var unit: BACUnit { model.unit }

    // MARK: Lane geometry
    //
    // The drinks used to be annotated onto the curve's own baseline, which put
    // their icons inside the plot, on top of the band. Instead the y-scale is
    // extended below zero and the drinks live in that strip: still on the same
    // time axis — which is the whole point, the marks have to line up with the
    // curve — but outside the area the curve occupies.
    //
    // The curve keeps a fixed height and the lane grows downwards under it, so
    // a busy evening costs screen rather than legibility.

    private static let curveHeight: CGFloat = 200
    private static let rowHeight: CGFloat = 24
    private static let lanePadding: CGFloat = 8
    private static let axisAllowance: CGFloat = 30

    /// Beyond this the chart is taller than it is useful. What does not fit is
    /// put on the last row and may overlap there — in practice this only
    /// happens to a whole evening typed in afterwards, all stamped "now".
    private static let maxLevels = 6

    /// How much two drinks may overlap and still share a row.
    ///
    /// Durations are whole minutes and every time on screen is shown to the
    /// minute, so an overlap of seconds is not an overlap anybody can see. It
    /// is easy to produce one: a beer started at 14:55:23 and given an hour
    /// runs to 15:55:23, and the next beer logged at 15:55:10 misses the test
    /// by thirteen seconds — then drops a row for a reason no one could name
    /// while looking at the screen.
    private static let overlapTolerance: TimeInterval = 60

    /// The smallest stretch of time a drink claims on its row.
    ///
    /// Its only job is to keep two drinks logged at the very same moment from
    /// being drawn on top of each other, so it has to be longer than the
    /// tolerance — otherwise it would not separate them either.
    private static let minimumFootprint: TimeInterval = 120

    private struct LaneRow: Identifiable {
        let drink: Drink
        let level: Int
        var id: UUID { drink.id }
    }

    /// The lane, worked out in a single pass.
    ///
    /// A value rather than a set of computed properties reading each other,
    /// because `chartXSelection` re-evaluates the body on every drag sample and
    /// the packing would otherwise run several times per mark, per frame.
    private struct LaneLayout {
        let rows: [LaneRow]
        let height: CGFloat
        let span: Double

        /// A distance in points inside the lane, in chart units.
        func units(_ points: CGFloat) -> Double {
            guard height > 0 else { return 0 }
            return span * Double(points / height)
        }

        /// The centre of a row, in chart units.
        func level(_ index: Int) -> Double {
            -units(BACChartView.lanePadding / 2
                   + BACChartView.rowHeight * (CGFloat(index) + 0.5))
        }
    }

    /// Packs the drinks into rows, first fit.
    ///
    /// Badges used to slide sideways to make room, with a dashed leader giving
    /// the real time back. Rows are better: a drink that does not fit beside
    /// its neighbour drops to the next row instead of drifting, so **every**
    /// badge sits on the moment it was drunk, and nothing has to be read back
    /// through a correction.
    ///
    /// **A row is a thread of drinking, and the test is overlap in time, not on
    /// screen.** A beer finished at half past and another started at half past
    /// share a row: they never coexisted. So do a beer given 30 minutes and the
    /// next one twenty minutes later, because logging that one already cut the
    /// first short (5.13) and the two now meet end to end. A shot pulled in the
    /// middle of a beer does not — that beer is still in your other hand, and
    /// the second row is the honest picture of it.
    ///
    /// The test runs to the minute, not to the second — see
    /// `overlapTolerance`, which is what keeps a beer that ran out at 15:55:23
    /// from evicting the one logged at 15:55:10.
    ///
    /// Sizing the footprint by the badge instead, as this once did, pushed
    /// drinks apart that had nothing to do with each other: at phone width a
    /// badge is about 6 % of the visible window, which is 20 minutes of a
    /// six-hour evening.
    private var laneLayout: LaneLayout {
        let ordered = model.drinks.sorted { $0.consumedAt < $1.consumedAt }
        guard !ordered.isEmpty else {
            return LaneLayout(rows: [], height: 0, span: 0)
        }

        var occupiedUntil: [Date] = []
        var rows: [LaneRow] = []

        for drink in ordered {
            let until = max(
                drink.finishedAt,
                drink.consumedAt.addingTimeInterval(Self.minimumFootprint)
            )
            let fits = drink.consumedAt.addingTimeInterval(Self.overlapTolerance)

            var index = occupiedUntil.firstIndex { $0 <= fits } ?? occupiedUntil.count
            index = min(index, Self.maxLevels - 1)

            if index < occupiedUntil.count {
                occupiedUntil[index] = max(occupiedUntil[index], until)
            } else {
                occupiedUntil.append(until)
            }
            rows.append(LaneRow(drink: drink, level: index))
        }

        let height = CGFloat(occupiedUntil.count) * Self.rowHeight + Self.lanePadding
        return LaneLayout(
            rows: rows,
            height: height,
            // So that the plot divides into a fixed-height curve and a lane of
            // exactly `height` points.
            span: model.yMaximum * Double(height / Self.curveHeight)
        )
    }

    /// The engine samples every minute — a 12-hour session is 720 points,
    /// more than is worth drawing. We thin to about 220, but always keep the
    /// peak, otherwise the top of the band would be clipped.
    private var displaySamples: [BACBandSample] {
        let samples = band.samples
        guard samples.count > 220 else { return samples }

        let step = max(samples.count / 220, 1)
        var thinned = samples.enumerated().compactMap { $0.offset % step == 0 ? $0.element : nil }

        if let peak = band.peak, !thinned.contains(where: { $0.date == peak.date }),
           let exact = samples.first(where: { $0.date == peak.date }) {
            thinned.append(exact)
            thinned.sort { $0.date < $1.date }
        }
        if let last = samples.last, thinned.last?.date != last.date {
            thinned.append(last)
        }
        return thinned
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            chart
            legend
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            headline
            Spacer()
            if model.isRising, scrubDate == nil {
                risingBadge
            }
        }
        .animation(.easeInOut(duration: 0.2), value: scrubDate)
    }

    @ViewBuilder
    private var headline: some View {
        if let scrubDate {
            labelledValue(
                title: Text(verbatim: scrubDate.hourMinute),
                range: band.range(at: scrubDate)
            )
        } else if let peak = model.upcomingPeak, let range = model.peakRange {
            labelledValue(
                title: Text("Expected peak around \(peak.date.hourMinute)"),
                range: range
            )
        } else if let peak = model.peak, let range = model.peakRange, peak.bac > 0 {
            labelledValue(
                title: Text("Peaked around \(peak.date.hourMinute)"),
                range: range,
                // A finished session is history, not a live reading.
                tint: model.isLive ? Theme.secondaryText : nil
            )
        } else {
            labelledPlaceholder(title: Text("No active session"))
        }
    }

    private func labelledValue(
        title: Text,
        range: ClosedRange<Double>,
        tint: Color? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            caption(title)
            BACReadout(range, unit: unit, limit: model.limit, size: 26, tint: tint)
        }
    }

    /// The no-session case has no figure to show, only a dash.
    private func labelledPlaceholder(title: Text) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            caption(title)
            Text(verbatim: "—")
                .font(.readout(26))
                .foregroundStyle(Theme.secondaryText)
        }
    }

    private func caption(_ title: Text) -> some View {
        title
            .font(.sectionLabel)
            .textCase(.uppercase)
            .foregroundStyle(Theme.secondaryText)
    }

    /// Marks the absorption limb. This is the one piece of information a
    /// breathalyser cannot give even in principle, so it is worth surfacing.
    private var risingBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: "arrow.up.right")
                .font(.system(size: 10, weight: .bold))
            Text("Still rising")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(Theme.caution)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(Theme.caution.opacity(0.14), in: Capsule())
    }

    // MARK: Chart

    private var chart: some View {
        let lane = laneLayout

        return Chart {
            laneBackground(lane)
            pourWindows(lane)
            uncertaintyBand
            centerLine
            limitRule
            baseline
            paceBars(lane)
            drinkBadges(lane)
            focusMarks
        }
        .chartXScale(domain: model.visibleRange)
        .chartYScale(domain: -lane.span...model.yMaximum)
        .chartXSelection(value: $scrubDate)
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .chartPlotStyle { plot in
            plot.background(Theme.surface.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(height: Self.curveHeight + lane.height + Self.axisAllowance)
        // The lane gains a row when a drink no longer fits beside its
        // neighbour. Letting that snap would read as a glitch.
        .animation(.easeInOut(duration: 0.25), value: lane.height)
    }

    /// The band: the area between fast and slow elimination.
    @ChartContentBuilder
    private var uncertaintyBand: some ChartContent {
        ForEach(displaySamples, id: \.date) { sample in
            AreaMark(
                x: .value("Time", sample.date),
                yStart: .value("Lower estimate", sample.low),
                yEnd: .value("Upper estimate", sample.high)
            )
            .foregroundStyle(bandGradient)
            .interpolationMethod(.monotone)
        }
    }

    @ChartContentBuilder
    private var centerLine: some ChartContent {
        ForEach(displaySamples, id: \.date) { sample in
            LineMark(
                x: .value("Time", sample.date),
                y: .value("Level", sample.mid)
            )
            .foregroundStyle(Theme.tint(for: model.peakRange?.upperBound ?? 0, limit: model.limit))
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            .interpolationMethod(.monotone)
        }
    }

    /// The fill is a vertical gradient, so colour varies with height and the
    /// shape of the band and the level can be read at the same time.
    ///
    /// Anchored to the level the band actually reaches, not to `yMaximum`.
    /// Now that the ramp is a fraction of the limit, `yMaximum` — which is at
    /// least 1.4 times the limit by construction — would put the top of every
    /// gradient in deep crimson, on a quiet evening as much as a heavy one.
    private var bandGradient: LinearGradient {
        let peak = model.peakRange?.upperBound ?? 0
        return LinearGradient(
            stops: [
                .init(color: Theme.tint(for: peak, limit: model.limit).opacity(0.45), location: 0),
                .init(color: Theme.tint(for: peak * 0.5, limit: model.limit).opacity(0.30), location: 0.55),
                .init(color: Theme.calm.opacity(0.16), location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    @ChartContentBuilder
    private var limitRule: some ChartContent {
        RuleMark(y: .value("Personal limit", model.limit))
            .foregroundStyle(Theme.alarm.opacity(0.5))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
            .annotation(position: .top, alignment: .trailing, spacing: 3) {
                Text("YOUR LIMIT \(unit.formatted(model.limit))")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.alarm.opacity(0.9))
            }
    }

    // MARK: The drink lane

    /// The strip the drinks sit in, darkened so it reads as its own register
    /// rather than as part of the plot.
    @ChartContentBuilder
    private func laneBackground(_ lane: LaneLayout) -> some ChartContent {
        if lane.span > 0 {
            RectangleMark(
                xStart: .value("Time", model.visibleRange.lowerBound),
                xEnd: .value("Time", model.visibleRange.upperBound),
                yStart: .value("Level", -lane.span),
                yEnd: .value("Level", 0)
            )
            .foregroundStyle(Theme.background.opacity(0.55))
        }
    }

    private var baseline: some ChartContent {
        RuleMark(y: .value("Level", 0))
            .foregroundStyle(Theme.hairline)
            .lineStyle(StrokeStyle(lineWidth: 1))
    }

    /// Each drink's own column, running the full height of the chart.
    ///
    /// Two jobs at once. In the curve area it marks the stretch of rise the
    /// drink is responsible for, which is the only thing that makes a length in
    /// the lane mean something. Through the lane it is the sight line: once
    /// there are five rows, a bar near the bottom is a long way from the time
    /// axis, and the column is what tells you which moment it belongs to.
    ///
    /// Drawn first, so it sits behind the curve and behind the rows.
    @ChartContentBuilder
    private func pourWindows(_ lane: LaneLayout) -> some ChartContent {
        ForEach(model.drinks) { drink in
            if drink.drinkingMinutes > 0 {
                RectangleMark(
                    xStart: .value("Drink", drink.consumedAt),
                    xEnd: .value("Drink", drink.finishedAt),
                    yStart: .value("Level", -lane.span),
                    yEnd: .value("Level", model.yMaximum)
                )
                .foregroundStyle(Color.white.opacity(0.05))
            } else {
                // Nothing to shade: a moment has no width. The dashed line is
                // the whole mark. Finer and dimmer than the now-line, which is
                // also dashed and must stay the louder of the two.
                RuleMark(x: .value("Drink", drink.consumedAt))
                    .foregroundStyle(Color.white.opacity(0.12))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [1.5, 2.5]))
            }
        }
    }

    /// How long each drink took, on its own row.
    ///
    /// A drink downed in one go has no bar — a bar of zero length is invisible,
    /// and padding it out to a stub would assert a duration that did not
    /// happen. Its badge simply sits alone on the row, in its dashed column.
    /// The difference between a span and a moment is then the presence or
    /// absence of the bar, which is as plain as it gets.
    @ChartContentBuilder
    private func paceBars(_ lane: LaneLayout) -> some ChartContent {
        ForEach(lane.rows) { row in
            if row.drink.drinkingMinutes > 0 {
                RectangleMark(
                    xStart: .value("Drink", row.drink.consumedAt),
                    xEnd: .value("Drink", row.drink.finishedAt),
                    yStart: .value("Level", lane.level(row.level) - lane.units(3.5)),
                    yEnd: .value("Level", lane.level(row.level) + lane.units(3.5))
                )
                .foregroundStyle(Color.white.opacity(0.22))
                .cornerRadius(3)

                // End cap: it makes the bar a measured span with a definite
                // end, rather than a shape that just stops.
                RuleMark(
                    x: .value("Drink", row.drink.finishedAt),
                    yStart: .value("Level", lane.level(row.level) - lane.units(7)),
                    yEnd: .value("Level", lane.level(row.level) + lane.units(7))
                )
                .foregroundStyle(Color.white.opacity(0.34))
                .lineStyle(StrokeStyle(lineWidth: 1.5, lineCap: .round))
            }
        }
    }

    /// One badge per drink, sitting on the start of its own bar.
    @ChartContentBuilder
    private func drinkBadges(_ lane: LaneLayout) -> some ChartContent {
        ForEach(lane.rows) { row in
            PointMark(
                x: .value("Drink", row.drink.consumedAt),
                y: .value("Level", lane.level(row.level))
            )
            .symbolSize(0)
            .annotation(position: .overlay, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                drinkBadge(row.drink)
            }
        }
    }

    /// Every badge looks the same. The pace is the bar row's job, and saying it
    /// twice would only make the badge carry meaning it cannot really hold.
    private func drinkBadge(_ drink: Drink) -> some View {
        Image(systemName: DrinkCatalog.icon(for: drink))
            .font(.system(size: 9, weight: .semibold))
            .foregroundStyle(Theme.secondaryText)
            .frame(width: 18, height: 18)
            .background(Theme.surfaceRaised, in: Circle())
            .overlay { Circle().strokeBorder(Color.white.opacity(0.18), lineWidth: 1) }
    }

    /// The now-marker, and the scrub read-out.
    ///
    /// A finished session has no "now", so it only gets a marker while the
    /// user is actually dragging across it.
    @ChartContentBuilder
    private var focusMarks: some ChartContent {
        if !model.drinks.isEmpty, let date = scrubDate ?? model.focusDate {
            let range = band.range(at: date)
            let isScrubbing = scrubDate != nil

            RuleMark(x: .value("Now", date))
                .foregroundStyle(Color.white.opacity(isScrubbing ? 0.4 : 0.18))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: isScrubbing ? [] : [3, 3]))

            // The focus point is a range too: two end markers, not one dot.
            PointMark(x: .value("Now", date), y: .value("Lower", range.lowerBound))
                .symbolSize(38)
                .foregroundStyle(Theme.tint(for: range.lowerBound, limit: model.limit).opacity(0.7))

            PointMark(x: .value("Now", date), y: .value("Upper", range.upperBound))
                .symbolSize(38)
                .foregroundStyle(Theme.tint(for: range.upperBound, limit: model.limit).opacity(0.7))
        }
    }

    // MARK: Axes

    private var xAxis: some AxisContent {
        AxisMarks(preset: .aligned, values: .stride(by: .hour, count: strideHours)) { value in
            AxisGridLine().foregroundStyle(Theme.hairline)
            AxisValueLabel {
                if let date = value.as(Date.self) {
                    Text(verbatim: date.hourMinute)
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
    }

    /// Thin out the labels on longer sessions so they do not collide.
    /// In an English locale AM/PM makes them wider, hence the earlier steps.
    private var strideHours: Int {
        let hours = model.visibleRange.upperBound
            .timeIntervalSince(model.visibleRange.lowerBound) / 3600
        return switch hours {
        case ..<7: 1
        case ..<14: 2
        default: 4
        }
    }

    /// Explicit ticks rather than `.automatic`, because the scale now runs into
    /// negative territory to make room for the drink lane — and a labelled
    /// −0.2 ‰ would be a nonsense reading.
    private var yTicks: [Double] {
        let step: Double = switch model.yMaximum {
        case ..<0.7: 0.2
        case ..<1.6: 0.5
        default: 1.0
        }
        return Array(stride(from: 0, through: model.yMaximum, by: step))
    }

    private var yAxis: some AxisContent {
        AxisMarks(position: .leading, values: yTicks) { value in
            AxisGridLine().foregroundStyle(Theme.hairline)
            AxisValueLabel {
                if let level = value.as(Double.self) {
                    Text(verbatim: unit.format(level))
                        .font(.system(size: 10, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
    }

    // MARK: Legend

    private var legend: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.calm.opacity(0.35))
                        .frame(width: 16, height: 9)
                    Text("possible range")
                }

                Text(verbatim: "·")

                if scrubDate == nil {
                    Text("drag to read values")
                } else {
                    Text("release to go back")
                }

                Spacer()
            }

            paceLegend
        }
        .font(.system(size: 10, design: .rounded))
        .foregroundStyle(Theme.secondaryText)
    }

    /// Only names the two marks that are actually on screen. On an evening of
    /// shots there is no bar to explain, and vice versa.
    @ViewBuilder
    private var paceLegend: some View {
        let hasPour = model.drinks.contains { $0.drinkingMinutes > 0 }
        let hasInstant = model.drinks.contains { $0.drinkingMinutes <= 0 }

        if hasPour || hasInstant {
            HStack(spacing: 12) {
                if hasPour {
                    HStack(spacing: 6) {
                        Capsule()
                            .fill(Color.white.opacity(0.22))
                            .frame(width: 16, height: 5)
                        Text("pour time")
                    }
                }
                if hasInstant {
                    HStack(spacing: 6) {
                        VerticalDash()
                            .stroke(
                                Color.white.opacity(0.45),
                                style: StrokeStyle(lineWidth: 1, dash: [1.5, 2.5])
                            )
                            .frame(width: 2, height: 10)
                        Text("in one go")
                    }
                }
                Spacer()
            }
        }
    }
}

/// The legend swatch for a drink that was downed in one go — the same dashed
/// line the chart draws for it.
private struct VerticalDash: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

@MainActor
private struct ChartPreview: View {
    private let store = SessionStore.preview

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            BACChartView(model: store.chartModel)
                .padding()
        }
    }
}

#Preview {
    ChartPreview()
}
