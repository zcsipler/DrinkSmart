import Foundation

/// An earlier drink, cut short because the next one of its kind arrived.
public struct PourCut: Equatable, Sendable {
    public let drinkID: UUID

    /// The duration the interrupted drink should be given, in minutes. Always
    /// shorter than what it had, and always greater than zero.
    public let drinkingMinutes: Double

    public init(drinkID: UUID, drinkingMinutes: Double) {
        self.drinkID = drinkID
        self.drinkingMinutes = drinkingMinutes
    }
}

public extension Array where Element == Drink {

    /// Which earlier drink the arrival of `candidate` says has been finished.
    ///
    /// Starting a second beer is evidence about the first: you are not holding
    /// two of them. So a drink of the **same kind** that was still being sipped
    /// at that moment is cut short there — the 30 minutes it was given were a
    /// default, and now there is something better than a default to go on.
    ///
    /// A different kind is not evidence at all. A shot in the middle of a beer
    /// says nothing about the beer, and cutting it short there would invent a
    /// faster rise than actually happened. Kind is `Drink.name`, which the app
    /// fills with the drink template's identifier.
    ///
    /// Only the most recent match is returned: anything older than that was
    /// already cut short by the drink in between.
    ///
    /// The operation is idempotent. Once cut, the earlier drink is no longer
    /// pouring at that instant, so a second pass over the same list finds
    /// nothing — which is what lets a projection be recomputed on every
    /// keystroke without the durations walking downwards.
    func pourCut(by candidate: Drink) -> PourCut? {
        let start = candidate.consumedAt

        let interrupted = self
            .filter { $0.id != candidate.id }
            .filter { $0.name == candidate.name }
            .filter { $0.drinkingMinutes > 0 }
            .filter { $0.consumedAt < start && $0.finishedAt > start }
            .max { $0.consumedAt < $1.consumedAt }

        guard let interrupted else { return nil }

        return PourCut(
            drinkID: interrupted.id,
            drinkingMinutes: start.timeIntervalSince(interrupted.consumedAt) / 60
        )
    }

    /// The same drinks, with `pourCut(by:)` applied.
    ///
    /// The projection uses this so that the curve previewed before adding a
    /// drink is the curve you get after adding it. Without it the preview would
    /// be drawn from durations the app is about to overwrite.
    func shorteningPour(for candidate: Drink) -> [Drink] {
        guard let cut = pourCut(by: candidate) else { return self }

        return map { drink in
            guard drink.id == cut.drinkID else { return drink }
            var shortened = drink
            shortened.drinkingMinutes = cut.drinkingMinutes
            return shortened
        }
    }
}
