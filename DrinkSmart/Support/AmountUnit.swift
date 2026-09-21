import Foundation
import BACKit

/// How much alcohol a figure stands for: grams of ethanol, or standard units.
///
/// The model counts in standard units (`Drink.standardUnits`, 10 g each), and
/// the two are a factor of ten apart — so this is display only, like
/// `BACUnit`. Grams is the default: a gram means the same thing everywhere,
/// while a "unit" is 8 g in Britain, 10 in Hungary and 12 in France, and a
/// number whose definition you have to look up is not a number you learn.
enum AmountUnit: String, CaseIterable, Codable, Identifiable, Sendable {
    case grams
    case standardUnits

    var id: String { rawValue }

    /// The full name, for the settings row.
    var label: LocalizedStringResource {
        switch self {
        case .grams: "Grams of alcohol"
        case .standardUnits: "Standard units"
        }
    }

    /// The word over a figure in a stat row or on an axis.
    var shortLabel: LocalizedStringResource {
        switch self {
        case .grams: "Grams"
        case .standardUnits: "Units"
        }
    }

    /// What the settings row shows in brackets. Not localized: "g" is a
    /// symbol, and "10 g" is the definition, not a word.
    var suffix: String {
        switch self {
        case .grams: "g"
        case .standardUnits: "10 g"
        }
    }

    func convert(standardUnits: Double) -> Double {
        switch self {
        case .grams: standardUnits * Physiology.gramsPerStandardUnit
        case .standardUnits: standardUnits
        }
    }

    /// Whole grams, or units to one decimal — the same resolution either way.
    func format(standardUnits: Double) -> String {
        convert(standardUnits: standardUnits).formatted(
            .number
                .precision(.fractionLength(self == .grams ? 0 : 1))
                .grouping(.never)
        )
    }

    /// With the symbol where there is one: "334 g", or "33.4" — a unit count
    /// has no symbol, and the label next to it says what it is.
    func formatted(standardUnits: Double) -> String {
        switch self {
        case .grams: "\(format(standardUnits: standardUnits)) g"
        case .standardUnits: format(standardUnits: standardUnits)
        }
    }
}
