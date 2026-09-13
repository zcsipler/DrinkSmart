import Foundation
import BACKit

/// A proxy for the elimination rate.
///
/// Beta on its own is an unanswerable question for a user — but everyone knows
/// how often they drink. Chronic intake induces the CYP2E1/MEOS pathway, so
/// regular drinkers have a measurably higher elimination rate.
///
/// The values stay inside the 0.10–0.25 g/L/h range reported in the
/// literature; the uncertainty is deliberately wide, because this estimate
/// remains the model's weakest point.
enum DrinkingFrequency: String, Codable, CaseIterable, Identifiable {
    case rarely
    case occasional
    case regular
    case daily

    var id: String { rawValue }

    var label: LocalizedStringResource {
        switch self {
        case .rarely: "Rarely"
        case .occasional: "A few times a month"
        case .regular: "Several times a week"
        case .daily: "Almost daily"
        }
    }

    var detail: LocalizedStringResource {
        switch self {
        case .rarely: "A few occasions a year"
        case .occasional: "Social drinking"
        case .regular: "Weekly routine"
        case .daily: "Daily or nearly daily"
        }
    }

    /// Centre value of beta in g/L/h.
    var beta: Double {
        switch self {
        case .rarely: 0.13
        case .occasional: 0.15
        case .regular: 0.18
        case .daily: 0.20
        }
    }

    /// ± uncertainty. Between-individual spread is substantial even among
    /// infrequent drinkers, and grows with frequency.
    var uncertainty: Double {
        switch self {
        case .rarely: 0.025
        case .occasional: 0.030
        case .regular: 0.035
        case .daily: 0.040
        }
    }

    /// The closest step to an existing beta value, so a value set by hand in
    /// the advanced settings can still be mapped back.
    static func closest(toBeta beta: Double) -> DrinkingFrequency {
        allCases.min { abs($0.beta - beta) < abs($1.beta - beta) } ?? .occasional
    }

    func apply(to profile: inout BodyProfile) {
        profile.beta = beta
        profile.betaUncertainty = uncertainty
    }
}
