import SwiftUI
import Charts

/// One of the two trend curves, over the whole recorded span: how much per
/// day, or how high on the days you drank (`HistoryTrend`).
///
/// A line, not bars: at a year's zoom the days would blur into a comb, and
/// zooming a comb has nothing to reveal. The chart scrolls sideways and
/// pinches to zoom; both cards share the same visible span and position
/// through the two bindings, so the peak under a given month is the peak of
/// the month the amount card is showing. The smoothing follows the zoom,
/// and the caption under the chart says what it is.
///
/// **Amount** is drawn as a smooth curve and filled to the floor. **Peak**
/// steps: flat from one evening to the next, because nothing is known in
/// between, with the evenings themselves as dots under the curve and the
/// limit across it, as on the live chart. The peak card colours by height
/// against the limit (5.14); the amount card has no limit to be measured
/// against and stays in the calm colour.
struct HistoryTrendChartView: View {

    enum Metric {
        case amount, peak
    }

    let trend: HistoryTrend
    let metric: Metric
    let amountUnit: AmountUnit
    let unit: BACUnit
    /// The limit to draw across the peak card: today's, because the question
    /// the card asks is how the past measures against the line you hold now.
    let limit: Double
    let now: Date

    /// Days on screen. Shared between the two cards, changed by the pinch.
    @Binding var visibleDays: Int
    /// The date at the leading edge. Shared for the same reason.
    @Binding var scrollX: Date

    /// The span at the start of a pinch, so a pinch scales from where it
    /// began rather than compounding on every update.
    @State private var pinchBase: Int?

    static let minimumVisibleDays = 14
    static let maximumVisibleDays = 366 * 10

    private let calendar = Calendar.current

    // MARK: Data

    private var points: [HistoryTrend.Point] {
        switch metric {
        case .amount: trend.amount
        case .peak: trend.peak
        }
    }

    /// The point's value in the unit on screen.
    private func y(_ value: Double) -> Double {
        switch metric {
        case .amount: amountUnit.convert(standardUnits: value)
        case .peak: unit.convert(value)
        }
    }

    /// A day's point sits at its noon, so today's is not on the edge and the
    /// first is not clipped.
    private func x(_ day: DrinkingDay) -> Date {
        calendar.startOfDay(for: day.calendarDate).addingTimeInterval(12 * 3600)
    }

    private var domain: ClosedRange<Date> {
        let end = calendar.startOfDay(for: now).addingTimeInterval(24 * 3600)
        let firstDay = trend.amount.first?.day.calendarDate ?? now
        let start = min(
            calendar.startOfDay(for: firstDay),
            end.addingTimeInterval(-Double(Self.minimumVisibleDays) * 86_400)
        )
        return start...end
    }

    private var visibleLength: TimeInterval { Double(visibleDays) * 86_400 }

    /// Whether there is more recorded than fits on screen. A chart that
    /// scrolls when everything is already visible only rubber-bands back
    /// on every drag — with a few weeks of records that was the first thing
    /// the screen did, and it read as broken.
    private var isScrollable: Bool {
        domain.upperBound.timeIntervalSince(domain.lowerBound) > visibleLength + 3600
    }

    /// The scroll position, kept inside the domain. Two charts share the
    /// binding, and an over-scrolled value from one would be handed to the
    /// other as a position to jump to — and then bounce back from.
    private var clampedScrollX: Binding<Date> {
        Binding(
            get: { scrollX },
            set: { newValue in
                let latest = domain.upperBound.addingTimeInterval(-visibleLength)
                let clamped = min(max(newValue, domain.lowerBound), max(latest, domain.lowerBound))
                if abs(clamped.timeIntervalSince(scrollX)) > 1 { scrollX = clamped }
            }
        )
    }

    private var yMaximum: Double {
        switch metric {
        case .amount:
            let tallest = trend.amount.map { y($0.value) }.max() ?? 0
            return max(amountUnit.convert(standardUnits: 1), tallest * 1.25)
        case .peak:
            let tallest = trend.peaks.map { y($0.value) }.max() ?? 0
            return max(unit.convert(limit) * 1.3, tallest * 1.15)
        }
    }

    // MARK: Body

    var body: some View {
        // The axis title is a plain view above the plot, not a
        // `chartYAxisLabel`: inside a scrollable chart that label lived in
        // the scrolling content and was only on screen mid-drag.
        VStack(alignment: .leading, spacing: 6) {
            axisTitle
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)

            scrolling(
                Chart {
                    switch metric {
                    case .amount: amountMarks
                    case .peak: peakMarks
                    }
                }
                .chartXScale(domain: domain)
                .chartYScale(domain: 0...yMaximum)
                .chartXAxis { xAxis }
                .chartYAxis { yAxis }
            )
            .simultaneousGesture(pinch)
            .frame(height: 180)
        }
    }

    /// Scrolling only when there is somewhere to scroll to.
    @ViewBuilder
    private func scrolling(_ chart: some View) -> some View {
        if isScrollable {
            chart
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: visibleLength)
                .chartScrollPosition(x: clampedScrollX)
        } else {
            chart
        }
    }

    @ChartContentBuilder
    private var amountMarks: some ChartContent {
        ForEach(trend.amount) { point in
            AreaMark(
                x: .value("Period", x(point.day)),
                y: .value("Units", y(point.value))
            )
            .interpolationMethod(.monotone)
            .foregroundStyle(
                LinearGradient(
                    colors: [Theme.calm.opacity(0.28), Theme.calm.opacity(0.02)],
                    startPoint: .top, endPoint: .bottom
                )
            )

            LineMark(
                x: .value("Period", x(point.day)),
                y: .value("Units", y(point.value))
            )
            .interpolationMethod(.monotone)
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            .foregroundStyle(Theme.calm)
        }
    }

    @ChartContentBuilder
    private var peakMarks: some ChartContent {
        ForEach(trend.peaks) { point in
            PointMark(
                x: .value("Period", x(point.day)),
                y: .value("peak", y(point.value))
            )
            .symbolSize(14)
            .foregroundStyle(Theme.tint(for: point.value, limit: limit).opacity(0.4))
        }

        // The curve holds its last value up to today: the trend does not end
        // on the last evening, it is what you carry into the next one.
        ForEach(peakLine) { point in
            LineMark(
                x: .value("Period", point.x),
                y: .value("peak", y(point.value))
            )
            .interpolationMethod(.stepEnd)
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .foregroundStyle(peakGradient)
        }

        RuleMark(y: .value("Personal limit", unit.convert(limit)))
            .foregroundStyle(Theme.alarm.opacity(0.5))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
    }

    private struct LinePoint: Identifiable {
        let x: Date
        let value: Double
        var id: Date { x }
    }

    private var peakLine: [LinePoint] {
        var line = trend.peak.map { LinePoint(x: x($0.day), value: $0.value) }
        if let last = trend.peak.last {
            let today = x(DrinkingDay.containing(now, calendar: calendar))
            if today > x(last.day) {
                line.append(LinePoint(x: today, value: last.value))
            }
        }
        return line
    }

    /// Height against the limit, the way the live band is coloured: the same
    /// five stops (5.14), placed where they fall on this chart's axis.
    private var peakGradient: LinearGradient {
        let fractions: [Double] = [0, 0.55, 0.85, 1.0, 1.5]
        let top = yMaximum
        let stops = fractions.map { fraction in
            Gradient.Stop(
                color: Theme.tint(for: limit * fraction, limit: limit),
                location: min(1, unit.convert(limit * fraction) / top)
            )
        }
        return LinearGradient(stops: stops, startPoint: .bottom, endPoint: .top)
    }

    // MARK: Zoom

    /// Pinching scales the visible span around its centre, so the month
    /// under your fingers stays under your fingers.
    private var pinch: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let base = pinchBase ?? visibleDays
                pinchBase = base
                let wanted = Int((Double(base) / value.magnification).rounded())
                let clamped = min(Self.maximumVisibleDays, max(Self.minimumVisibleDays, wanted))
                guard clamped != visibleDays else { return }
                let centre = scrollX.addingTimeInterval(Double(visibleDays) * 86_400 / 2)
                visibleDays = clamped
                scrollX = centre.addingTimeInterval(-Double(clamped) * 86_400 / 2)
            }
            .onEnded { _ in pinchBase = nil }
    }

    // MARK: Axes

    private var axisTitle: Text {
        switch metric {
        case .amount: Text(amountUnit.shortLabel) + Text(verbatim: " / ") + Text("day")
        case .peak: Text("peak")
        }
    }

    /// Tick spacing follows the zoom: weeks under two months, months under
    /// two years, years beyond.
    private var xAxis: some AxisContent {
        AxisMarks(preset: .aligned, values: xTicks) { value in
            AxisGridLine().foregroundStyle(Theme.hairline)
            AxisValueLabel(collisionResolution: .greedy) {
                if let date = value.as(Date.self) {
                    Text(verbatim: xLabel(for: date))
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(Theme.secondaryText)
                        .lineLimit(1)
                        .fixedSize()
                }
            }
        }
    }

    private var xTicks: AxisMarkValues {
        if visibleDays < 60 { return .stride(by: .day, count: 7) }
        if visibleDays < 730 { return .stride(by: .month) }
        return .stride(by: .year)
    }

    private func xLabel(for date: Date) -> String {
        if visibleDays < 60 { return date.formatted(.dateTime.month(.abbreviated).day()) }
        if visibleDays < 730 {
            // The year at each January, so a scroll through years stays placed.
            return calendar.component(.month, from: date) == 1
                ? date.formatted(.dateTime.month(.abbreviated).year(.twoDigits))
                : date.formatted(.dateTime.month(.abbreviated))
        }
        return date.formatted(.dateTime.year())
    }

    private var yAxis: some AxisContent {
        AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
            AxisGridLine().foregroundStyle(Theme.hairline)
            AxisValueLabel {
                if let level = value.as(Double.self) {
                    Text(verbatim: yLabel(level))
                        .font(.system(size: 10, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
    }

    private func yLabel(_ level: Double) -> String {
        switch metric {
        case .amount: level.formatted(.number.precision(.fractionLength(0)))
        case .peak: level.formatted(.number.precision(.fractionLength(unit == .perMille ? 1 : 2)))
        }
    }
}
