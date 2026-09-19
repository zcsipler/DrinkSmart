import SwiftUI

/// A blood alcohol figure.
///
/// Every headline figure in the app goes through here, so what the app claims
/// about its own precision is decided in one place.
///
/// ## One number or a range
///
/// Both, and the user picks which. The view always takes the band; it prints a
/// single number when the band has no width and a range when it has. Nothing
/// here decides the question — `betaUncertainty` does, from the profile.
///
/// The default is zero, so the app opens showing single numbers. The reason is
/// what the figure is *for*: a personal reference scale you learn over time —
/// what 0.6 feels like for you. A range has no fixed point for that memory to
/// attach to. The uncertainty is also **systematic per person, not random
/// noise**: if your true rate is 0.18 and the app assumes 0.15, every figure is
/// off in the same direction by about the same amount, and a consistent bias is
/// harmless for a scale you calibrate yourself against.
///
/// Turning the uncertainty up is a deliberate step into the other mode, where
/// the app stops asserting a point and reports the spread instead. That is the
/// honest reading of what the model knows, and it is worth offering — it is
/// just not the right thing to hand someone on first launch.
///
/// The spread is shown regardless where it changes what you would do: the
/// clearing **time**, where it can mean four hours, and the band on the chart,
/// which says "this is a model" without any number becoming fuzzy.
struct BACReadout: View {
    let range: ClosedRange<Double>
    let unit: BACUnit

    /// Point size of the figure. The unit suffix scales from it.
    var size: CGFloat = 48

    /// Colour of the figure. Defaults to the level's own tint.
    var tint: Color?

    init(_ range: ClosedRange<Double>, unit: BACUnit, size: CGFloat = 48, tint: Color? = nil) {
        self.range = range
        self.unit = unit
        self.size = size
        self.tint = tint
    }

    /// A figure that is a point by construction rather than by setting.
    init(value: Double, unit: BACUnit, size: CGFloat = 48, tint: Color? = nil) {
        self.init(value...value, unit: unit, size: size, tint: tint)
    }

    /// What the colour reacts to. The middle of the band, so the tint does not
    /// jump when the user widens the uncertainty.
    private var midpoint: Double { range.midpoint }

    /// A range is roughly twice as wide as a single figure, so it needs more
    /// room to shrink into before it truncates.
    private var minimumScale: CGFloat {
        unit.formatRange(range).contains("–") ? 0.5 : 0.7
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: size * 0.11) {
            Text(verbatim: unit.formatRange(range))
                .font(.readout(size))
                .foregroundStyle(tint ?? Theme.tint(for: midpoint))
                .lineLimit(1)
                .minimumScaleFactor(minimumScale)
                .contentTransition(.numericText())

            Text(verbatim: unit.suffix)
                .font(.system(size: size * 0.42, weight: .light, design: .rounded))
                .foregroundStyle(Theme.secondaryText)
        }
        .animation(.easeInOut(duration: 0.25), value: midpoint)
    }
}

extension ClosedRange where Bound == Double {
    /// The middle of a band — the single figure that stands for it.
    var midpoint: Double { (lowerBound + upperBound) / 2 }

    /// Whether the band has collapsed to a point.
    var isPoint: Bool { lowerBound == upperBound }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 30) {
            BACReadout(value: 0.58, unit: .perMille, size: 48)
            BACReadout(0.52...0.64, unit: .perMille, size: 48)
            BACReadout(value: 1.24, unit: .perMille, size: 26)
            BACReadout(0.52...0.64, unit: .percent, size: 22)
            BACReadout(value: 0.32, unit: .perMille, size: 22, tint: Theme.secondaryText)
        }
        .padding()
    }
}
