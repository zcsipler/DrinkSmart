import Foundation

/// A megjelenítés mértékegysége. A motor mindig g/L-ben számol.
enum BACUnit: String, CaseIterable, Codable, Identifiable {
    /// Ezrelék — a magyar és a kontinentális európai konvenció. 1 g/L = 1 ‰.
    case perMille
    /// Százalék — az amerikai konvenció. 1 g/L = 0,1 %.
    case percent

    var id: String { rawValue }

    var suffix: String {
        switch self {
        case .perMille: "‰"
        case .percent: "%"
        }
    }

    var label: String {
        switch self {
        case .perMille: "Ezrelék (‰)"
        case .percent: "Százalék (%)"
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

    func format(_ gramsPerLiter: Double) -> String {
        let value = convert(gramsPerLiter)
        return value.formatted(
            .number
                .precision(.fractionLength(fractionDigits))
                .grouping(.never)
        )
    }

    func formatted(_ gramsPerLiter: Double) -> String {
        "\(format(gramsPerLiter)) \(suffix)"
    }

    /// Tartomány mértékegység nélkül: „0,52–0,64”.
    ///
    /// Ha a két vég a megjelenített pontosságon belül egybeesik, egyetlen
    /// számot ad — nem írunk ki „0,52–0,52” alakot.
    func formatRange(_ range: ClosedRange<Double>) -> String {
        let low = format(range.lowerBound)
        let high = format(range.upperBound)
        return low == high ? low : "\(low)–\(high)"
    }

    func formattedRange(_ range: ClosedRange<Double>) -> String {
        "\(formatRange(range)) \(suffix)"
    }
}

extension ClosedRange where Bound == Date {
    /// Időtartomány: „19:00–22:00”, vagy egyetlen időpont, ha egybeesnek.
    var hourMinuteRange: String {
        let from = lowerBound.hourMinute
        let to = upperBound.hourMinute
        return from == to ? from : "\(from)–\(to)"
    }
}

extension TimeInterval {
    /// „3 ó 20 p" alakú, rövid időtartam.
    var compactDuration: String {
        guard self > 0 else { return "—" }
        let totalMinutes = Int(rounded() / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours == 0 { return "\(minutes) p" }
        if minutes == 0 { return "\(hours) ó" }
        return "\(hours) ó \(minutes) p"
    }
}

extension Date {
    var hourMinute: String {
        formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
    }
}
