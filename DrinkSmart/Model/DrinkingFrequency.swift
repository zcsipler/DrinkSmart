import Foundation
import BACKit

/// A lebontási sebesség proxyja.
///
/// A béta önmagában megválaszolhatatlan kérdés egy felhasználónak — viszont
/// azt mindenki tudja magáról, milyen gyakran iszik. A krónikus bevitel
/// indukálja a CYP2E1/MEOS útvonalat, ezért a rendszeres fogyasztók
/// eliminációs rátája mérhetően magasabb.
///
/// A számok az irodalmi 0,10–0,25 g/L/h tartományon belül mozognak; a
/// bizonytalanság szándékosan széles, mert ez a becslés marad a modell
/// leggyengébb pontja.
enum DrinkingFrequency: String, Codable, CaseIterable, Identifiable {
    case rarely
    case occasional
    case regular
    case daily

    var id: String { rawValue }

    var label: String {
        switch self {
        case .rarely: "Ritkán"
        case .occasional: "Havonta párszor"
        case .regular: "Hetente többször"
        case .daily: "Szinte naponta"
        }
    }

    var detail: String {
        switch self {
        case .rarely: "Évente néhány alkalom"
        case .occasional: "Alkalmi, társasági fogyasztás"
        case .regular: "Heti rendszeresség"
        case .daily: "Napi vagy majdnem napi"
        }
    }

    /// A béta középértéke g/L/h-ban.
    var beta: Double {
        switch self {
        case .rarely: 0.13
        case .occasional: 0.15
        case .regular: 0.18
        case .daily: 0.20
        }
    }

    /// ± bizonytalanság. Az egyének közti szórás a ritkán fogyasztóknál is
    /// jelentős, a gyakoriaknál pedig tovább nő.
    var uncertainty: Double {
        switch self {
        case .rarely: 0.025
        case .occasional: 0.030
        case .regular: 0.035
        case .daily: 0.040
        }
    }

    /// A legközelebbi fokozat egy meglévő béta értékhez — a haladó
    /// beállításokban kézzel állított értéket is vissza tudjuk vetíteni.
    static func closest(toBeta beta: Double) -> DrinkingFrequency {
        allCases.min { abs($0.beta - beta) < abs($1.beta - beta) } ?? .occasional
    }

    func apply(to profile: inout BodyProfile) {
        profile.beta = beta
        profile.betaUncertainty = uncertainty
    }
}
