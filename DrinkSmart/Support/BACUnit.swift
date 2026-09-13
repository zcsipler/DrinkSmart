import Foundation

/// Display unit. The engine always computes in g/L.
enum BACUnit: String, CaseIterable, Codable, Identifiable {
    /// Per mille — the Hungarian and continental European convention. 1 g/L = 1 ‰.
    case perMille
    /// Percent — the US convention. 1 g/L = 0.1 %.
    case percent

    var id: String { rawValue }

    /// Symbol. Deliberately not localized: ‰ and % are international signs.
    var suffix: String {
        switch self {
        case .perMille: "‰"
        case .percent: "%"
        }
    }

    /// The symbol is deliberately left out: a literal `%` in the string
    /// catalog would look like a format specifier. The view appends it.
    var label: LocalizedStringResource {
        switch self {
        case .perMille: "Per mille"
        case .percent: "Percent"
        }
    }

    private var fractionDigits: Int {
        switch self {
        case .perMille: 2
        case .percent: 3
        }
    }

    func convert(_ gramsPerLiter: Double) -> Double {
        switch self {
        case .perMille: gramsPerLiter
        case .percent: gramsPerLiter / 10
        }
    }

    /// The `.number` style follows the system language, so it produces a
    /// decimal comma in Hungarian and a point in English without any manual
    /// formatting on our side.
    func format(_ gramsPerLiter: Double) -> String {
        convert(gramsPerLiter).formatted(
            .number
                .precision(.fractionLength(fractionDigits))
                .grouping(.never)
        )
    }

    func formatted(_ gramsPerLiter: Double) -> String {
        "\(format(gramsPerLiter)) \(suffix)"
    }

    /// A range without the unit: "0.52–0.64".
    ///
    /// Collapses to a single number when both ends agree at the displayed
    /// precision — we never print "0.52–0.52".
    func formatRange(_ range: ClosedRange<Double>) -> String {
        let low = format(range.lowerBound)
        let high = format(range.upperBound)
        return low == high ? low : "\(low)–\(high)"
    }

    func formattedRange(_ range: ClosedRange<Double>) -> String {
        "\(formatRange(range)) \(suffix)"
    }
}

extension TimeInterval {
    /// A short duration in the system language: "3h 20m", or "3 ó 20 p".
    ///
    /// `Duration.UnitsFormatStyle` localizes itself, so this text needs no
    /// translation — and it drops a zero hour component on its own.
    var compactDuration: String {
        guard self > 0 else { return "—" }
        let minutes = Int((self / 60).rounded())
        return Duration.seconds(minutes * 60).formatted(
            .units(allowed: [.hours, .minutes], width: .narrow, zeroValueUnits: .hide)
        )
    }
}

extension Date {
    /// Hours and minutes per the system settings — 24-hour in Hungarian,
    /// 12-hour with AM/PM in an English locale.
    var hourMinute: String {
        formatted(date: .omitted, time: .shortened)
    }
}

extension ClosedRange where Bound == Date {
    /// A time range: "19:00–22:00", or a single time when they coincide.
    var hourMinuteRange: String {
        let from = lowerBound.hourMinute
        let to = upperBound.hourMinute
        return from == to ? from : "\(from)–\(to)"
    }
}
