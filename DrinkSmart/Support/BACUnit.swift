import Foundation

/// A megjelenítés mértékegysége. A motor mindig g/L-ben számol.
enum BACUnit: String, CaseIterable, Codable, Identifiable {
    /// Ezrelék — a magyar és a kontinentális európai konvenció. 1 g/L = 1 ‰.
    case perMille
    /// Százalék — az amerikai konvenció. 1 g/L = 0,1 %.
    case percent

    var id: String { rawValue }

    /// Szimbólum. Szándékosan nem lokalizált: a ‰ és a % nemzetközi jel.
    var suffix: String {
        switch self {
        case .perMille: "‰"
        case .percent: "%"
        }
    }

    /// A szimbólum szándékosan nincs benne: egy literál `%` a katalógusban
    /// formátumspecifikátornak látszana. A nézet külön fűzi hozzá.
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

    /// A `.number` stílus a rendszer nyelvét követi, tehát magyarul
    /// tizedesvesszőt ad, angolul tizedespontot — kézi formázás nélkül.
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

extension TimeInterval {
    /// Rövid időtartam a rendszer nyelvén: „3 ó 20 p”, illetve „3h 20m”.
    ///
    /// A `Duration.UnitsFormatStyle` maga lokalizál, ezért ezt a szöveget
    /// nem kell fordítanunk — és a nulla órát is elhagyja.
    var compactDuration: String {
        guard self > 0 else { return "—" }
        let minutes = Int((self / 60).rounded())
        return Duration.seconds(minutes * 60).formatted(
            .units(allowed: [.hours, .minutes], width: .narrow, zeroValueUnits: .hide)
        )
    }
}

extension Date {
    /// Óra és perc a rendszer beállítása szerint — magyarul 24 órás,
    /// angol locale-ban 12 órás AM/PM alakban.
    var hourMinute: String {
        formatted(date: .omitted, time: .shortened)
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
