import SwiftUI
import Charts
import BACKit

/// A véralkohol-görbe. Az app központi képernyője.
///
/// Sávot rajzol, nem vonalat. A lebontási sebesség a plauzibilis tartományán
/// belül 40 % fölött mozgatja a csúcsot és több órát a kiürülésen — egyetlen
/// vonal olyan pontosságot állítana, ami nincs meg. A sáv szélessége maga is
/// információ: azt mutatja, mennyire tudjuk, amit állítunk.
///
/// Amit szándékosan NEM mutat: verdiktet. Se „vezethetsz", se „biztonságos".
struct BACChartView: View {
    let store: SessionStore

    /// A scrub gesztus alatt kiválasztott időpont.
    @State private var scrubDate: Date?

    private var band: BACBand { store.band }
    private var unit: BACUnit { store.unit }

    /// A motor percenkénti mintákat ad — egy 12 órás alkalom 720 pont, amit
    /// felesleges kirajzolni. Ritkítunk kb. 220 pontra, de a csúcsot mindig
    /// megtartjuk, különben a sáv teteje levágódna.
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

    // MARK: Fejléc

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            if let scrubDate {
                labelledValue(
                    title: scrubDate.hourMinute,
                    value: unit.formatRange(band.range(at: scrubDate)),
                    tint: Theme.tint(for: band.value(at: scrubDate))
                )
            } else if let peak = store.upcomingPeak, let range = store.peakRange {
                labelledValue(
                    title: "Várható csúcs \(peak.date.hourMinute) körül",
                    value: unit.formatRange(range),
                    tint: Theme.tint(for: peak.bac)
                )
            } else if let peak = store.peak, let range = store.peakRange, peak.bac > 0 {
                labelledValue(
                    title: "Csúcs volt \(peak.date.hourMinute) körül",
                    value: unit.formatRange(range),
                    tint: Theme.secondaryText
                )
            } else {
                labelledValue(title: "Nincs aktív alkalom", value: "—", tint: Theme.secondaryText)
            }

            Spacer()

            if store.isRising, scrubDate == nil, !store.drinks.isEmpty {
                risingBadge
            }
        }
        .animation(.easeInOut(duration: 0.2), value: scrubDate)
    }

    private func labelledValue(title: String, value: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.sectionLabel)
                .foregroundStyle(Theme.secondaryText)
            Text(value)
                .font(.readout(26))
                .foregroundStyle(tint)
        }
    }

    /// A felszálló ág jelzése. Ez az egyetlen információ, amit egy szonda
    /// elvileg sem tud megadni — érdemes kiemelni.
    private var risingBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: "arrow.up.right")
                .font(.system(size: 10, weight: .bold))
            Text("Még emelkedik")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(Theme.caution)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(Theme.caution.opacity(0.14), in: Capsule())
    }

    // MARK: A diagram

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

    /// A sáv: a gyors és a lassú lebontás közti terület.
    @ChartContentBuilder
    private var uncertaintyBand: some ChartContent {
        ForEach(displaySamples, id: \.date) { sample in
            AreaMark(
                x: .value("Idő", sample.date),
                yStart: .value("Alsó becslés", sample.low),
                yEnd: .value("Felső becslés", sample.high)
            )
            .foregroundStyle(bandGradient)
            .interpolationMethod(.monotone)
        }
    }

    @ChartContentBuilder
    private var centerLine: some ChartContent {
        ForEach(displaySamples, id: \.date) { sample in
            LineMark(
                x: .value("Idő", sample.date),
                y: .value("Szint", sample.mid)
            )
            .foregroundStyle(Theme.tint(for: store.peakRange?.upperBound ?? 0))
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            .interpolationMethod(.monotone)
        }
    }

    /// A kitöltés függőleges gradiens: a szín a magassággal változik, így a
    /// sáv alakja és a szint egyszerre olvasható.
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
        RuleMark(y: .value("Saját határ", store.limit))
            .foregroundStyle(Theme.elevated.opacity(0.55))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
            .annotation(position: .top, alignment: .trailing, spacing: 3) {
                Text("SAJÁT HATÁR \(unit.formatted(store.limit))")
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.elevated.opacity(0.85))
            }
    }

    @ChartContentBuilder
    private var drinkMarkers: some ChartContent {
        ForEach(store.drinks) { drink in
            RuleMark(x: .value("Ital", drink.consumedAt))
                .foregroundStyle(Color.white.opacity(0.07))
                .lineStyle(StrokeStyle(lineWidth: 1))

            PointMark(
                x: .value("Ital", drink.consumedAt),
                y: .value("Szint", 0)
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

            RuleMark(x: .value("Most", date))
                .foregroundStyle(Color.white.opacity(scrubDate == nil ? 0.18 : 0.4))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: scrubDate == nil ? [3, 3] : []))

            // A fókuszpont is tartomány: két végjelölő, nem egyetlen pötty.
            PointMark(x: .value("Most", date), y: .value("Alsó", range.lowerBound))
                .symbolSize(38)
                .foregroundStyle(Theme.tint(for: range.lowerBound).opacity(0.7))

            PointMark(x: .value("Most", date), y: .value("Felső", range.upperBound))
                .symbolSize(38)
                .foregroundStyle(Theme.tint(for: range.upperBound).opacity(0.7))
        }
    }

    // MARK: Tengelyek

    private var xAxis: some AxisContent {
        AxisMarks(preset: .aligned, values: .stride(by: .hour, count: strideHours)) { value in
            AxisGridLine().foregroundStyle(Theme.hairline)
            AxisValueLabel {
                if let date = value.as(Date.self) {
                    Text(date.hourMinute)
                        .font(.system(size: 10, design: .rounded))
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
    }

    /// Hosszabb alkalomnál ritkítjuk a címkéket, hogy ne torlódjanak.
    private var strideHours: Int {
        let hours = store.visibleRange.upperBound
            .timeIntervalSince(store.visibleRange.lowerBound) / 3600
        return switch hours {
        case ..<8: 1
        case ..<16: 2
        default: 4
        }
    }

    private var yAxis: some AxisContent {
        AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
            AxisGridLine().foregroundStyle(Theme.hairline)
            AxisValueLabel {
                if let level = value.as(Double.self) {
                    Text(unit.format(level))
                        .font(.system(size: 10, design: .rounded).monospacedDigit())
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
    }

    // MARK: Jelmagyarázat

    private var legend: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.calm.opacity(0.35))
                    .frame(width: 16, height: 9)
                Text("lehetséges tartomány")
            }

            Text("·")

            Text(scrubDate == nil ? "húzd a leolvasáshoz" : "engedd el a visszatéréshez")

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
