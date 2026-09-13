import SwiftUI
import Charts
import BACKit

/// The blood alcohol curve. The app's central screen.
///
/// It draws a band, not a line. Across its plausible range the elimination
/// rate shifts the peak by over 40 % and the time to clear by hours — a single
/// line would claim a precision that is not there. The width of the band is
/// itself information: it shows how well we know what we are asserting.
///
/// What it deliberately does NOT show: a verdict. No "you can drive", no "safe".
struct BACChartView: View {
    let store: SessionStore

    /// The time selected while scrubbing.
    @State private var scrubDate: Date?

    private var band: BACBand { store.band }
    private var unit: BACUnit { store.unit }

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
            if store.isRising, scrubDate == nil, !store.drinks.isEmpty {
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
                value: unit.formatRange(band.range(at: scrubDate)),
                tint: Theme.tint(for: band.value(at: scrubDate))
            )
        } else if let peak = store.upcomingPeak, let range = store.peakRange {
            labelledValue(
                title: Text("Expected peak around \(peak.date.hourMinute)"),
                value: unit.formatRange(range),
                tint: Theme.tint(for: peak.bac)
            )
        } else if let peak = store.peak, let range = store.peakRange, peak.bac > 0 {
            labelledValue(
                title: Text("Peaked around \(peak.date.hourMinute)"),
                value: unit.formatRange(range),
                tint: Theme.secondaryText
            )
        } else {
            labelledValue(
                title: Text("No active session"),
                value: "—",
                tint: Theme.secondaryText
            )
        }
    }

    private func labelledValue(title: Text, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            title
                .font(.sectionLabel)
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: value)
                .font(.readout(26))
                .foregroundStyle(tint)
        }
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
        Chart {
            uncertaintyBand
            centerLine
            limitRule
            drinkMarkers
            focusMarks
        }
        .chartXScale(domain: store.visibleRange)
        .chartYScale(domain: 0...store.yMaximum)
        .chartXSelection(value: $scrubDate)
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .chartPlotStyle { plot in
            plot.background(Theme.surface.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(height: 260)
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
            .foregroundStyle(Theme.tint(for: store.peakRange?.upperBound ?? 0))
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            .interpolationMethod(.monotone)
        }
    }

    /// The fill is a vertical gradient, so colour varies with height and the
    /// shape of the band and the level can be read at the same time.
    private var bandGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: Theme.tint(for: store.yMaximum).opacity(0.45), location: 0),
                .init(color: Theme.tint(for: store.yMaximum * 0.5).opacity(0.30), location: 0.55),
                .init(color: Theme.calm.opacity(0.16), location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    @ChartContentBuilder
    private var limitRule: some ChartContent {
        RuleMark(y: .value("Personal limit", store.limit))
            .foregroundStyle(Theme.elevated.opacity(0.55))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
            .annotation(position: .top, alignment: .trailing, spacing: 3) {
                Text("YOUR LIMIT \(unit.formatted(store.limit))")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.elevated.opacity(0.85))
            }
    }

    @ChartContentBuilder
    private var drinkMarkers: some ChartContent {
        ForEach(store.drinks) { drink in
            RuleMark(x: .value("Drink", drink.consumedAt))
                .foregroundStyle(Color.white.opacity(0.07))
                .lineStyle(StrokeStyle(lineWidth: 1))

            PointMark(
                x: .value("Drink", drink.consumedAt),
                y: .value("Level", 0)
            )
            .symbolSize(0)
            .annotation(position: .top, spacing: 2) {
                Image(systemName: DrinkCatalog.icon(for: drink))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Theme.secondaryText)
            }
        }
    }

    @ChartContentBuilder
    private var focusMarks: some ChartContent {
        if !store.drinks.isEmpty {
            let date = scrubDate ?? store.now
            let range = band.range(at: date)

            RuleMark(x: .value("Now", date))
                .foregroundStyle(Color.white.opacity(scrubDate == nil ? 0.18 : 0.4))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: scrubDate == nil ? [3, 3] : []))

            // The focus point is a range too: two end markers, not one dot.
            PointMark(x: .value("Now", date), y: .value("Lower", range.lowerBound))
                .symbolSize(38)
                .foregroundStyle(Theme.tint(for: range.lowerBound).opacity(0.7))

            PointMark(x: .value("Now", date), y: .value("Upper", range.upperBound))
                .symbolSize(38)
                .foregroundStyle(Theme.tint(for: range.upperBound).opacity(0.7))
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
        let hours = store.visibleRange.upperBound
            .timeIntervalSince(store.visibleRange.lowerBound) / 3600
        return switch hours {
        case ..<7: 1
        case ..<14: 2
        default: 4
        }
    }

    private var yAxis: some AxisContent {
        AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
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
        .font(.system(size: 10, design: .rounded))
        .foregroundStyle(Theme.secondaryText)
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        BACChartView(store: .preview)
            .padding()
    }
}
