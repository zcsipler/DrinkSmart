import SwiftUI
import UIKit

/// Az app vizuális nyelve. Sötét alap, a görbe színe pedig a szinttel változik:
/// nyugodt türkiz alul, borostyán középen, meleg korall a tetején.
/// A szín így önmagában is információt hordoz, nem csak dekoráció.
enum Theme {
    static let background = Color(red: 0.043, green: 0.051, blue: 0.071)
    static let surface = Color(red: 0.086, green: 0.098, blue: 0.129)
    static let surfaceRaised = Color(red: 0.129, green: 0.145, blue: 0.184)
    static let hairline = Color.white.opacity(0.08)

    static let primaryText = Color(red: 0.937, green: 0.945, blue: 0.961)
    static let secondaryText = Color(red: 0.561, green: 0.588, blue: 0.643)

    static let calm = Color(red: 0.271, green: 0.749, blue: 0.706)      // türkiz
    static let caution = Color(red: 0.949, green: 0.714, blue: 0.310)   // borostyán
    static let elevated = Color(red: 0.937, green: 0.427, blue: 0.396)  // korall

    /// A szintnek megfelelő szín. A töréspontok szándékosan lágyak — a
    /// farmakokinetika folytonos, nem lépcsős, és a színezés se sugalljon
    /// éles kategóriahatárokat.
    static func tint(for bac: Double) -> Color {
        switch bac {
        case ..<0.3: calm
        case ..<0.5: blend(calm, caution, t: (bac - 0.3) / 0.2)
        case ..<0.8: caution
        case ..<1.3: blend(caution, elevated, t: (bac - 0.8) / 0.5)
        default: elevated
        }
    }

    private static func blend(_ a: Color, _ b: Color, t: Double) -> Color {
        let t = min(max(t, 0), 1)
        let ca = rgba(a), cb = rgba(b)
        return Color(
            red: ca.r + (cb.r - ca.r) * t,
            green: ca.g + (cb.g - ca.g) * t,
            blue: ca.b + (cb.b - ca.b) * t
        )
    }

    /// `getRed(_:green:blue:alpha:)` szürkeárnyalatos színtérre is helyesen
    /// válaszol, ellentétben a `cgColor.components` indexeléssel.
    private static func rgba(_ color: Color) -> (r: Double, g: Double, b: Double, a: Double) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}

extension Font {
    /// A hero kijelző számjegyei. Monospaced, hogy ne ugráljon a szám másodpercenként.
    static func readout(_ size: CGFloat) -> Font {
        .system(size: size, weight: .light, design: .rounded).monospacedDigit()
    }

    static var sectionLabel: Font {
        .system(size: 11, weight: .semibold, design: .rounded)
    }
}
