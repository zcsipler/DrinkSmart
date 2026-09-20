import SwiftUI
import UIKit

/// The app's visual language. Dark ground, and a curve whose colour tracks the
/// level: calm teal low down, amber in the middle, warm coral at the top.
/// The colour therefore carries information rather than being decoration.
enum Theme {
    static let background = Color(red: 0.043, green: 0.051, blue: 0.071)
    static let surface = Color(red: 0.086, green: 0.098, blue: 0.129)
    static let surfaceRaised = Color(red: 0.129, green: 0.145, blue: 0.184)
    static let hairline = Color.white.opacity(0.08)

    static let primaryText = Color(red: 0.937, green: 0.945, blue: 0.961)
    static let secondaryText = Color(red: 0.561, green: 0.588, blue: 0.643)

    static let calm = Color(red: 0.271, green: 0.749, blue: 0.706)      // teal
    static let caution = Color(red: 0.949, green: 0.714, blue: 0.310)   // amber
    static let elevated = Color(red: 0.937, green: 0.427, blue: 0.396)  // coral
    static let alarm = Color(red: 0.925, green: 0.176, blue: 0.196)     // red
    static let critical = Color(red: 0.745, green: 0.043, blue: 0.157)  // deep crimson

    /// The colour for a level, read **against the limit that person set**.
    ///
    /// Not an absolute scale. The old one turned amber at 0.5 ‰ and topped out
    /// at coral above 1.3 ‰, the same for everyone — which made the colour a
    /// claim about drinking in general rather than about this person. Someone
    /// who set 0.3 ‰ saw their whole evening in teal; someone who set 1.2 ‰ was
    /// already in coral well below their own line.
    ///
    /// The ramp is anchored to the limit instead, so full red lands exactly
    /// where you said your line was, and keeps deepening past it. The limit is
    /// the user's own number, so this is not the app handing down a verdict —
    /// it is the app being consistent with the one the user already wrote down.
    ///
    /// Continuous between the stops. Pharmacokinetics is not stepped, and the
    /// colour should not imply category boundaries the model does not have.
    static func tint(for bac: Double, limit: Double) -> Color {
        // A limit of zero would make everything infinitely over it.
        interpolate(levelRamp, at: bac / max(limit, 0.05))
    }

    /// Stops as a fraction of the limit.
    private static var levelRamp: [(at: Double, color: Color)] {
        [
            (0.00, calm),
            (0.55, caution),
            (0.85, elevated),
            (1.00, alarm),
            (1.50, critical),
        ]
    }

    private static func interpolate(_ stops: [(at: Double, color: Color)], at x: Double) -> Color {
        guard let first = stops.first, let last = stops.last else { return calm }
        if x <= first.at { return first.color }
        if x >= last.at { return last.color }

        for (lower, upper) in zip(stops, stops.dropFirst()) where x < upper.at {
            return blend(lower.color, upper.color, t: (x - lower.at) / (upper.at - lower.at))
        }
        return last.color
    }

    /// The colour tagging a person in the switcher.
    ///
    /// Only ever on the chip. The level colours above mean something — how
    /// close you are to your own limit — and a second colour system on the same
    /// screen would make both of them noise.
    static func accent(for accent: PersonAccent) -> Color {
        switch accent {
        case .teal: calm
        case .violet: Color(red: 0.604, green: 0.514, blue: 0.937)
        case .amber: caution
        case .rose: Color(red: 0.929, green: 0.475, blue: 0.639)
        case .sky: Color(red: 0.365, green: 0.624, blue: 0.941)
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

    /// `getRed(_:green:blue:alpha:)` answers correctly for greyscale colour
    /// spaces too, unlike indexing into `cgColor.components`.
    private static func rgba(_ color: Color) -> (r: Double, g: Double, b: Double, a: Double) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}

extension Font {
    /// Digits for the hero readout. Monospaced so the number does not jitter
    /// as it ticks.
    static func readout(_ size: CGFloat) -> Font {
        .system(size: size, weight: .light, design: .rounded).monospacedDigit()
    }

    static var sectionLabel: Font {
        .system(size: 11, weight: .semibold, design: .rounded)
    }
}
