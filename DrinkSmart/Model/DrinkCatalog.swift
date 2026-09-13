import Foundation
import BACKit

/// Egy italtípus a gyors felvitelhez: alapértelmezett kiszerelés, alkoholfok
/// és a tipikus térfogatok, amikből egy koppintással lehet választani.
struct DrinkTemplate: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let defaultVolumeMl: Double
    let defaultAbv: Double
    let volumeOptions: [Double]
    let abvRange: ClosedRange<Double>

    func makeDrink(at date: Date, volumeMl: Double, abv: Double, stomach: StomachState) -> Drink {
        Drink(consumedAt: date, volumeMl: volumeMl, abvPercent: abv, stomach: stomach, name: name)
    }
}

enum DrinkCatalog {
    static let all: [DrinkTemplate] = [
        DrinkTemplate(
            id: "beer", name: "Sör", icon: "mug.fill",
            defaultVolumeMl: 500, defaultAbv: 5,
            volumeOptions: [250, 330, 400, 500], abvRange: 0.5...12
        ),
        DrinkTemplate(
            id: "wine", name: "Bor", icon: "wineglass.fill",
            defaultVolumeMl: 150, defaultAbv: 12,
            volumeOptions: [100, 125, 150, 200], abvRange: 5...18
        ),
        DrinkTemplate(
            id: "sparkling", name: "Pezsgő", icon: "waterbottle.fill",
            defaultVolumeMl: 125, defaultAbv: 12,
            volumeOptions: [100, 125, 150, 200], abvRange: 5...15
        ),
        DrinkTemplate(
            id: "spirit", name: "Tömény", icon: "drop.fill",
            defaultVolumeMl: 40, defaultAbv: 40,
            volumeOptions: [20, 40, 50, 80], abvRange: 15...96
        ),
        DrinkTemplate(
            id: "cocktail", name: "Koktél", icon: "cup.and.saucer.fill",
            defaultVolumeMl: 200, defaultAbv: 15,
            volumeOptions: [150, 200, 250, 330], abvRange: 3...40
        ),
        DrinkTemplate(
            id: "custom", name: "Egyedi", icon: "slider.horizontal.3",
            defaultVolumeMl: 100, defaultAbv: 10,
            volumeOptions: [50, 100, 200, 330], abvRange: 0.5...96
        ),
    ]

    static func template(id: String) -> DrinkTemplate {
        all.first { $0.id == id } ?? all[0]
    }

    /// Ikon egy már rögzített italhoz. Először név szerint keres, ha az nem
    /// egyértelmű, az alkoholfok alapján tippel — így importált vagy régi
    /// adatokra sem marad ikon nélkül.
    static func icon(for drink: Drink) -> String {
        if let name = drink.name, let match = all.first(where: { $0.name == name }) {
            return match.icon
        }
        return switch drink.abvPercent {
        case 25...: "drop.fill"
        case 9..<25: "wineglass.fill"
        default: "mug.fill"
        }
    }
}

// MARK: - Gyomorállapot megjelenítése

extension StomachState {
    var label: String {
        switch self {
        case .empty: "Éhgyomor"
        case .light: "Közepesen telt"
        case .full: "Teli has"
        }
    }

    var shortLabel: String {
        switch self {
        case .empty: "Éhgyomor"
        case .light: "Közepes"
        case .full: "Teli"
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
    var explanation: String {
        switch self {
        case .empty: "Gyors felszívódás, magasabb és korábbi csúcs."
        case .light: "Mérsékelt felszívódás."
        case .full: "Lassú felszívódás, alacsonyabb és későbbi csúcs."
        }
    }
}
