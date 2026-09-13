import Foundation
import BACKit

/// Egy italtípus a gyors felvitelhez: alapértelmezett kiszerelés, alkoholfok
/// és a tipikus térfogatok, amikből egy koppintással lehet választani.
struct DrinkTemplate: Identifiable, Hashable {
    let id: String
    let name: LocalizedStringResource
    let icon: String
    let defaultVolumeMl: Double
    let defaultAbv: Double
    let volumeOptions: [Double]
    let abvRange: ClosedRange<Double>

    /// A rögzített ital a sablon **azonosítóját** hordozza, nem a nevét —
    /// különben a mentett adat nyelvhez kötődne, és nyelvváltás után
    /// angol nevek maradnának a magyar felületen.
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

    /// A sablon egy már rögzített italhoz. Először azonosító szerint keres,
    /// ha az nem talál, az alkoholfok alapján tippel — így importált vagy
    /// régi adatokra sem marad ikon és név nélkül.
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

// MARK: - Gyomorállapot megjelenítése

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

    /// Rövid magyarázat, ami megindokolja, miért számít ez a választás.
    var explanation: LocalizedStringResource {
        switch self {
        case .empty: "Fast absorption, higher and earlier peak."
        case .light: "Moderate absorption."
        case .full: "Slow absorption, lower and later peak."
        }
    }
}
