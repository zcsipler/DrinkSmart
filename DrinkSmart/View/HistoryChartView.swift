import SwiftUI
import Charts

/// Units per day (or per month, in the year view) as bars.
///
/// The bar says how much; its colour says how high it went, read against the
/// limit in force that day (5.14) — so a long quiet evening and a short sharp
/// one look different even at the same height. A bar with no valid cached
/// peak is drawn neutral rather than guessed at; the store fills the cache in
/// the background and the colour arrives with it.
///
/// Days before records began are shaded, not left blank: blank is what a dry
/// day looks like, and the two are not the same thing (5.7).
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
    let window: HistoryWindow
    let amountUnit: AmountUnit

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

    /// Room above the tallest bar for its value label, and never so low that
    /// a single beer fills the chart. Three units is a modest evening; a scale
    /// that tops out below it would make every bar shout.
    private var yMaximum: Double {
        let tallest = window.bars.map { amount($0) }.max() ?? 0
        let floor = amountUnit.convert(standardUnits: 3)
        return max(floor, (tallest * 1.25).rounded(.up))
    }

    /// The bar's height in the unit on screen.
    private func amount(_ bar: HistoryBar) -> Double {
        amountUnit.convert(standardUnits: bar.totalUnits)
    }

    var body: some View {
        Chart {
            ForEach(window.bars) { bar in
                if bar.state == .unknown {
                    RectangleMark(
                        xStart: .value("Period", plotInterval(bar.interval).start),
                        xEnd: .value("Period", plotInterval(bar.interval).end),
                        yStart: .value("Units", 0),
                        yEnd: .value("Units", yMaximum)
                    )
                    .foregroundStyle(Theme.surfaceRaised.opacity(0.45))
                }

                if bar.state == .drank {
                    BarMark(
                        x: .value("Period", bar.interval.start, unit: barUnit),
                        y: .value("Units", amount(bar))
                    )
                    .foregroundStyle(tint(for: bar).opacity(selectedBarID == nil || selectedBarID == bar.id ? 1 : 0.45))
                    .cornerRadius(3)
                    .annotation(position: .top, spacing: 4) {
                        if selectedBarID == bar.id {
                            Text(verbatim: amountUnit.formatted(standardUnits: bar.totalUnits))
                                .font(.system(size: 11, weight: .semibold, design: .rounded).monospacedDigit())
                                .foregroundStyle(Theme.primaryText)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Theme.surfaceRaised, in: RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
        }
        .chartXScale(domain: xDomain)
        .chartYScale(domain: 0...yMaximum)
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .chartYAxisLabel(position: .topLeading, alignment: .leading) {
            Text(amountUnit.shortLabel)
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
            .filter { $0.state == .drank }
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

    /// Peak against the limit of that day. Dry bars are not drawn at all, and
    /// a bar whose peak is still being recomputed stays neutral.
    private func tint(for bar: HistoryBar) -> Color {
        guard let peak = bar.peakRange, let limit = bar.limit else {
            return Theme.calm.opacity(0.45)
        }
        return Theme.tint(for: peak.midpoint, limit: limit)
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
        case .week: .stride(by: .day)
        case .month: .stride(by: .day, count: 7)
        case .year: .stride(by: .month)
        }
    }

    private func xLabel(for date: Date) -> String {
        switch window.range {
        case .week:
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
                if let units = value.as(Double.self) {
                    Text(verbatim: units.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(size: 10, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
    }
}
