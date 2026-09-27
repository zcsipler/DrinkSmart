import SwiftUI
import Charts
import BACKit

/// One bar per day (or per month, in the year view), for one of two metrics.
///
/// **Amount**: the bar says how much, and so does its colour — by grams per
/// day the bar covers, on one fixed scale for every range
/// (`Theme.tint(forGrams:overDays:)`), so a heavy week and a heavy month are
/// the same red. **Peak**: the bar is the day's highest level, coloured
/// against the limit in force that day (5.14), with the limit drawn across as
/// a dashed line, the same way the live chart draws it. Two cards rather than
/// a toggle, so the two can be read against each other without switching.
///
/// The amount chart used to borrow the peak's colour, so that a long quiet
/// evening and a short sharp one looked different at the same height. That
/// held for a day and broke for a month: a month bar has no single peak, and
/// its worst evening would have painted a light month red. Each chart now
/// colours by the thing it draws, and the pair says what the one could not.
/// A peak bar with no valid cached peak is drawn neutral rather than guessed
/// at; the store fills the cache in the background and the colour arrives
/// with it.
///
/// Days before records began are shaded, not left blank: blank is what a dry
/// day looks like, and the two are not the same thing (5.7). The shading says
/// so in words when there is room — a grey block was read as "something is
/// wrong with the chart", not as "we were not looking yet".
///
/// Tapping a bar shows its exact value above it, and that is all a tap does.
/// A second tap used to drill into the month or week under the bar; it read
/// as the screen changing on its own, because nothing said the second tap
/// meant something else. Range changes belong to the range picker.
///
/// A tap snaps to the nearest bar with something in it, within a thumb's
/// width. A month's bars are a few points wide, and asking anyone to land on
/// one exactly is asking them to miss.
struct HistoryChartView: View {

    enum Metric {
        /// Alcohol consumed, in the user's amount unit.
        case amount
        /// The highest estimated level of the day, in the user's BAC unit.
        case peak
    }

    let window: HistoryWindow
    let metric: Metric
    let amountUnit: AmountUnit
    let unit: BACUnit

    /// When this person's records begin. Named in the shaded region, because
    /// a grey block on its own does not say what it is.
    let recordsBegan: Date

    @State private var selectedBarID: HistoryBar.ID?

    /// How far, in points, a tap may land from a bar's centre and still count.
    private static let hitSlop: CGFloat = 16

    private var barUnit: Calendar.Component {
        window.range.barPeriod == .day ? .day : .month
    }

    /// A drinking day starts at 05:00, but a bar binned to `.day` is drawn
    /// over the calendar day. Everything on the x-axis is aligned to midnight
    /// so the first bar of the week is not clipped by five hours.
    private func plotInterval(_ interval: DateInterval) -> DateInterval {
        let calendar = Calendar.current
        return DateInterval(
            start: calendar.startOfDay(for: interval.start),
            end: calendar.startOfDay(for: interval.end)
        )
    }

    private var xDomain: ClosedRange<Date> {
        let plot = plotInterval(window.interval)
        return plot.start...plot.end
    }

    /// Room above the tallest bar for its value label, and a floor so a quiet
    /// window does not blow one small bar up to fill the chart. For amounts
    /// the floor is three units, a modest evening; for peaks it is the limit
    /// with headroom, so the limit line always has bars to be measured against.
    private var yMaximum: Double {
        let tallest = window.bars.compactMap { value($0) }.max() ?? 0
        switch metric {
        case .amount:
            let floor = amountUnit.convert(standardUnits: 3)
            return max(floor, (tallest * 1.25).rounded(.up))
        case .peak:
            let limit = window.limit ?? 0.8
            return max(limit * 1.3, tallest * 1.25)
        }
    }

    /// The bar's height in the unit on screen. Nil when there is nothing to
    /// draw: a peak whose cache has not been refilled yet is not zero, it is
    /// not known, and a bar of zero would say otherwise.
    ///
    /// A month known only by total has an amount and nothing else — a bar on
    /// the amount chart when the bar is the whole month (the year view), no
    /// bar on the peak chart, and no bar for a single day of it.
    private func value(_ bar: HistoryBar) -> Double? {
        switch (bar.state, metric) {
        case (.drank, .amount):
            return amountUnit.convert(standardUnits: bar.totalUnits)
        case (.drank, .peak):
            return bar.peakRange.map { unit.convert($0.midpoint) }
        case (.summarized, .amount) where bar.totalUnits > 0:
            return amountUnit.convert(standardUnits: bar.totalUnits)
        default:
            return nil
        }
    }

    /// The fill of a region that stands for a month's total in the week and
    /// month views: the month's colour on the amount scale, over all its
    /// known days, faded so the bars of recorded days beside it stay the
    /// foreground. The legend's swatch is the neutral version.
    static func summarizedTint(for month: SummarizedMonth) -> Color {
        Theme.tint(forGrams: month.gramsEthanol, overDays: max(1, month.unknownDays))
    }

    /// The legend's swatch for a summarized month, which cannot pick one
    /// month's colour to stand for all.
    static let neutralSummarizedTint = Theme.secondaryText.opacity(0.35)

    /// What the value bubble says. The peak is printed as a range where the
    /// band is wide (5.8) — the bar can only stand at its midpoint.
    private func label(_ bar: HistoryBar) -> String {
        switch metric {
        case .amount:
            return amountUnit.formatted(standardUnits: bar.totalUnits)
        case .peak:
            return bar.peakRange.map { unit.formattedRange($0) } ?? ""
        }
    }

    /// The plot-aligned span of the days before records began, if any. The
    /// aggregate guarantees these are a run at the front of the window; taking
    /// the prefix rather than every unknown bar keeps that true here even if
    /// the guarantee ever slips.
    private var unknownRegion: DateInterval? {
        let unknown = window.bars.prefix { $0.state == .unknown }
        guard let first = unknown.first, let last = unknown.last else { return nil }
        return DateInterval(
            start: plotInterval(first.interval).start,
            end: plotInterval(last.interval).end
        )
    }

    /// How much of the window the unknown run covers. Under about a third
    /// the label would not fit; the legend under the chart still names it.
    private var unknownShare: Double {
        guard !window.bars.isEmpty else { return 0 }
        return Double(window.bars.prefix { $0.state == .unknown }.count) / Double(window.bars.count)
    }

    /// Runs of day bars covered by a month's total, one region per month —
    /// the week and month views' way of showing a month that has a sum but
    /// no days. Empty in the year view, where such a month is a bar. A week
    /// can straddle two such months, hence a list.
    private struct SummarizedRegion: Identifiable {
        let interval: DateInterval
        let month: SummarizedMonth
        let barCount: Int
        var id: Date { interval.start }
    }

    private var summarizedRegions: [SummarizedRegion] {
        guard window.range.barPeriod == .day else { return [] }
        var regions: [SummarizedRegion] = []
        for bar in window.bars {
            guard bar.state == .summarized, let month = bar.summarizedMonth else { continue }
            let plot = plotInterval(bar.interval)
            if let last = regions.last, last.month == month, last.interval.end == plot.start {
                regions[regions.count - 1] = SummarizedRegion(
                    interval: DateInterval(start: last.interval.start, end: plot.end),
                    month: month,
                    barCount: last.barCount + 1
                )
            } else {
                regions.append(SummarizedRegion(interval: plot, month: month, barCount: 1))
            }
        }
        return regions
    }

    private var axisTitle: LocalizedStringResource {
        switch metric {
        case .amount: amountUnit.shortLabel
        case .peak: "peak"
        }
    }

    var body: some View {
        Chart {
            // One block for the whole run of unknown days, not one per day:
            // the label needs the full width, and the days before records
            // are always a single run at the start of the window.
            if let unknown = unknownRegion {
                RectangleMark(
                    xStart: .value("Period", unknown.start),
                    xEnd: .value("Period", unknown.end),
                    yStart: .value("Units", 0),
                    yEnd: .value("Units", yMaximum)
                )
                .foregroundStyle(Theme.surfaceRaised.opacity(0.45))
                .annotation(position: .overlay, alignment: .center) {
                    if unknownShare >= 0.3 {
                        Text("No data before \(recordsBegan.formatted(date: .abbreviated, time: .omitted))")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundStyle(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .padding(.horizontal, 6)
                    }
                }
            }

            // A month known by total, seen day by day: shaded like the
            // pre-record run but in its own tint, and named with the figure
            // that does exist when the run is wide enough to carry a label.
            ForEach(summarizedRegions) { region in
                RectangleMark(
                    xStart: .value("Period", region.interval.start),
                    xEnd: .value("Period", region.interval.end),
                    yStart: .value("Units", 0),
                    yEnd: .value("Units", yMaximum)
                )
                .foregroundStyle(Self.summarizedTint(for: region.month).opacity(0.22))
                .annotation(position: .overlay, alignment: .center) {
                    if Double(region.barCount) / Double(max(1, window.bars.count)) >= 0.3 {
                        Text("Monthly total: \(amountUnit.formatted(standardUnits: region.month.month.totalUnits))")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundStyle(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .padding(.horizontal, 6)
                    }
                }
            }

            ForEach(window.bars) { bar in
                if let height = value(bar) {
                    BarMark(
                        x: .value("Period", bar.interval.start, unit: barUnit),
                        y: .value("Units", height)
                    )
                    .foregroundStyle(tint(for: bar).opacity(selectedBarID == nil || selectedBarID == bar.id ? 1 : 0.45))
                    .cornerRadius(3)
                    .annotation(position: .top, spacing: 4) {
                        if selectedBarID == bar.id {
                            Text(verbatim: label(bar))
                                .font(.system(size: 11, weight: .semibold, design: .rounded).monospacedDigit())
                                .foregroundStyle(Theme.primaryText)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Theme.surfaceRaised, in: RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }

            // The same line the live chart draws (5.14): the user's own
            // number, the strictest in force during the window.
            if metric == .peak, let limit = window.limit {
                RuleMark(y: .value("Personal limit", unit.convert(limit)))
                    .foregroundStyle(Theme.alarm.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
            }
        }
        .chartXScale(domain: xDomain)
        .chartYScale(domain: 0...yMaximum)
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .chartYAxisLabel(position: .topLeading, alignment: .leading) {
            Text(axisTitle)
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        guard let plotFrame = proxy.plotFrame else { return }
                        let x = location.x - geometry[plotFrame].origin.x
                        tapped(atPlotX: x, proxy: proxy)
                    }
            }
        }
        .frame(height: 190)
        // A new window means new bars; a selection from the old one would
        // point at a date that is no longer on screen.
        .onChange(of: window) { selectedBarID = nil }
    }

    /// The bar whose centre is nearest the tap, if any lies within `hitSlop`.
    /// Only bars with something drawn count — a dry day has nothing to read.
    private func tapped(atPlotX x: CGFloat, proxy: ChartProxy) {
        let nearest = window.bars
            .filter { value($0) != nil }
            .compactMap { bar -> (bar: HistoryBar, distance: CGFloat)? in
                let plot = plotInterval(bar.interval)
                let centre = plot.start.addingTimeInterval(plot.duration / 2)
                guard let barX = proxy.position(forX: centre) else { return nil }
                return (bar, abs(barX - x))
            }
            .min { $0.distance < $1.distance }

        withAnimation(.easeOut(duration: 0.15)) {
            if let nearest, nearest.distance <= Self.hitSlop {
                selectedBarID = selectedBarID == nearest.bar.id ? nil : nearest.bar.id
            } else {
                selectedBarID = nil
            }
        }
    }

    // MARK: Colour

    /// Each chart by its own metric. Amount: grams over the bar's known
    /// days, one scale for every range, which is what lets a summarized
    /// month sit beside recorded ones without a second colour system. Peak:
    /// against the limit of that day; dry bars are not drawn at all, and a
    /// bar whose peak is still being recomputed stays neutral.
    private func tint(for bar: HistoryBar) -> Color {
        switch metric {
        case .amount:
            return Theme.tint(
                forGrams: bar.totalUnits * Physiology.gramsPerStandardUnit,
                overDays: bar.knownDays
            )
        case .peak:
            guard let peak = bar.peakRange, let limit = bar.limit else {
                return Theme.calm.opacity(0.45)
            }
            return Theme.tint(for: peak.midpoint, limit: limit)
        }
    }

    // MARK: Axes

    private var xAxis: some AxisContent {
        AxisMarks(preset: .aligned, values: xTicks) { value in
            // A label centred under its bar when every bar has one; on the
            // month view only every seventh day is labelled, and the label
            // then belongs to the tick, not to a bar. Collision resolution
            // is off: twelve month names are tight but must all be there —
            // Charts dropping every other one would read as missing months.
            AxisValueLabel(centered: window.range != .month, collisionResolution: .disabled) {
                if let date = value.as(Date.self) {
                    Text(verbatim: xLabel(for: date))
                        .font(.system(size: window.range == .year ? 9 : 10, design: .rounded))
                        .foregroundStyle(Theme.secondaryText)
                        .lineLimit(1)
                        .fixedSize()
                }
            }
        }
    }

    private var xTicks: AxisMarkValues {
        switch window.range {
        case .day, .week: .stride(by: .day)
        case .month: .stride(by: .day, count: 7)
        case .year: .stride(by: .month)
        }
    }

    private func xLabel(for date: Date) -> String {
        switch window.range {
        case .day, .week:
            return date.formatted(.dateTime.weekday(.abbreviated))
        case .month:
            return date.formatted(.dateTime.day())
        case .year:
            // Twelve labels across a phone: the locale's abbreviation, cut to
            // its first three letters where it runs longer (Hungarian
            // "szept." → "sze"), with any trailing full stop dropped.
            let short = date.formatted(.dateTime.month(.abbreviated))
                .trimmingCharacters(in: CharacterSet(charactersIn: "."))
            return short.count > 4 ? String(short.prefix(3)) : short
        }
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

    /// The amount axis in whole numbers; the peak axis in the BAC unit's own
    /// precision, already converted — `BACUnit.format` expects g/L.
    private func yLabel(_ level: Double) -> String {
        switch metric {
        case .amount: level.formatted(.number.precision(.fractionLength(0)))
        case .peak: level.formatted(.number.precision(.fractionLength(unit == .perMille ? 1 : 2)))
        }
    }
}
