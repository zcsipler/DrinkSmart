import Foundation
import SwiftData
import BACKit

/// A stored drink.
///
/// The persisted form is deliberately separate from `BACKit.Drink`: the engine
/// stays free of SwiftData, and the schema can change without touching the
/// model layer. `asDrink` is the bridge, and it keeps the same `id`, which is
/// what lets an edit find its way back to the right row.
///
/// Like the session, every property has a default so the schema is
/// CloudKit-compatible.
@Model
final class DrinkRecord {
    var id: UUID = UUID()
    var consumedAt: Date = Date.now
    var volumeMl: Double = 0
    var abvPercent: Double = 0

    /// `StomachState.rawValue`. Stored as a string rather than an enum,
    /// because a value CloudKit has never seen must still decode to something.
    var stomachRaw: String = StomachState.light.rawValue

    /// The `DrinkTemplate` identifier, e.g. "beer". Never a display name —
    /// that would tie stored data to a language.
    var templateID: String = "beer"

    var session: DrinkingSession?

    init(_ drink: Drink) {
        id = drink.id
        consumedAt = drink.consumedAt
        volumeMl = drink.volumeMl
        abvPercent = drink.abvPercent
        stomachRaw = drink.stomach.rawValue
        templateID = drink.name ?? "beer"
    }

    /// The value type the engine works with.
    var asDrink: Drink {
        Drink(
            id: id,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            abvPercent: abvPercent,
            stomach: StomachState(rawValue: stomachRaw) ?? .light,
            name: templateID
        )
    }

    /// Copies an edited drink back onto the stored row.
    func apply(_ drink: Drink) {
        consumedAt = drink.consumedAt
        volumeMl = drink.volumeMl
        abvPercent = drink.abvPercent
        stomachRaw = drink.stomach.rawValue
        templateID = drink.name ?? templateID
    }
}
