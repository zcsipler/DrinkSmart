import Foundation
import BACKit

/// A drink type for quick entry: default serving, strength, and the typical
/// volumes offered as one-tap options.
struct DrinkTemplate: Identifiable, Hashable {
    let id: String
    let name: LocalizedStringResource
    let icon: String
    let defaultVolumeMl: Double
    let defaultAbv: Double
    let volumeOptions: [Double]
    let abvRange: ClosedRange<Double>

    /// The recorded drink carries the template's **identifier**, not its name.
    /// Otherwise persisted data would be tied to a language, and English names
    /// would linger on a Hungarian interface after a language change.
    func makeDrink(at date: Date, volumeMl: Double, abv: Double, stomach: StomachState) -> Drink {
        Drink(consumedAt: date, volumeMl: volumeMl, abvPercent: abv, stomach: stomach, name: id)
    }

    static func == (lhs: DrinkTemplate, rhs: DrinkTemplate) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum DrinkCatalog {
    static let all: [DrinkTemplate] = [
        DrinkTemplate(
            id: "beer", name: "Beer", icon: "mug.fill",
            defaultVolumeMl: 500, defaultAbv: 5,
            volumeOptions: [250, 330, 400, 500], abvRange: 0.5...12
        ),
        DrinkTemplate(
            id: "wine", name: "Wine", icon: "wineglass.fill",
            defaultVolumeMl: 150, defaultAbv: 12,
            volumeOptions: [100, 125, 150, 200], abvRange: 5...18
        ),
        DrinkTemplate(
            id: "sparkling", name: "Sparkling", icon: "waterbottle.fill",
            defaultVolumeMl: 125, defaultAbv: 12,
            volumeOptions: [100, 125, 150, 200], abvRange: 5...15
        ),
        DrinkTemplate(
            id: "spirit", name: "Spirit", icon: "drop.fill",
            defaultVolumeMl: 40, defaultAbv: 40,
            volumeOptions: [20, 40, 50, 80], abvRange: 15...96
        ),
        DrinkTemplate(
            id: "cocktail", name: "Cocktail", icon: "cup.and.saucer.fill",
            defaultVolumeMl: 200, defaultAbv: 15,
            volumeOptions: [150, 200, 250, 330], abvRange: 3...40
        ),
        DrinkTemplate(
            id: "custom", name: "Custom", icon: "slider.horizontal.3",
            defaultVolumeMl: 100, defaultAbv: 10,
            volumeOptions: [50, 100, 200, 330], abvRange: 0.5...96
        ),
    ]

    static func template(id: String) -> DrinkTemplate {
        all.first { $0.id == id } ?? all[0]
    }

    /// The template for an already recorded drink. Looks up by identifier
    /// first, then guesses from the strength — so imported or legacy data
    /// never ends up without an icon and a name.
    static func template(for drink: Drink) -> DrinkTemplate {
        if let id = drink.name, let match = all.first(where: { $0.id == id }) {
            return match
        }
        return switch drink.abvPercent {
        case 25...: template(id: "spirit")
        case 9..<25: template(id: "wine")
        default: template(id: "beer")
        }
    }

    static func icon(for drink: Drink) -> String { template(for: drink).icon }

    static func name(for drink: Drink) -> LocalizedStringResource { template(for: drink).name }
}

// MARK: - Stomach state presentation

extension StomachState {
    var label: LocalizedStringResource {
        switch self {
        case .empty: "Empty stomach"
        case .light: "Moderately full"
        case .full: "Full stomach"
        }
    }

    var shortLabel: LocalizedStringResource {
        switch self {
        case .empty: "Empty"
        case .light: "Moderate"
        case .full: "Full"
        }
    }

    var icon: String {
        switch self {
        case .empty: "circle"
        case .light: "circle.lefthalf.filled"
        case .full: "circle.fill"
        }
    }

    /// A short explanation of why this choice matters.
    var explanation: LocalizedStringResource {
        switch self {
        case .empty: "Fast absorption, higher and earlier peak."
        case .light: "Moderate absorption."
        case .full: "Slow absorption, lower and later peak."
        }
    }
}
