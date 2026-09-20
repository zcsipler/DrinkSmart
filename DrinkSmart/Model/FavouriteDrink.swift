import Foundation
import BACKit

/// The drink the quick-add button logs, in one tap and without a sheet.
///
/// Chosen by hand in the profile rather than taken from the last drink logged.
/// An evening that goes beer, pálinka, Jäger has no meaningful "same again":
/// the last drink is evidence about that moment, not about what this person
/// usually orders. A standing choice is the only one that survives a mixed
/// evening.
///
/// **The stomach state is deliberately not part of it.** Every field here
/// survives the week — a pint is still half a litre next Friday — but a stomach
/// state picked once on the profile screen would assert something about every
/// evening afterwards, and that is the input that moves the slope of the rising
/// limb, which is the number the whole model exists for (2.). The quick add
/// inherits it from the previous drink of the running session instead, and
/// falls back to `.light`, which is what `AddDrinkSheet` already assumes when
/// nobody touches the control.
struct FavouriteDrink: Equatable {

    /// The `DrinkTemplate` identifier, never a display name — the same rule
    /// `DrinkRecord` follows, for the same reason.
    var templateID: String
    var volumeMl: Double
    var abvPercent: Double
    var drinkingMinutes: Double

    var template: DrinkTemplate { DrinkCatalog.template(id: templateID) }

    /// The drink to log. `stomach` comes from the caller, never from here.
    func drink(at date: Date, stomach: StomachState) -> Drink {
        template.makeDrink(
            at: date,
            volumeMl: volumeMl,
            abv: abvPercent,
            stomach: stomach,
            drinkingMinutes: drinkingMinutes
        )
    }

    /// A favourite built from a template's own defaults — what the editor
    /// opens on when nothing has been chosen yet.
    init(_ template: DrinkTemplate) {
        templateID = template.id
        volumeMl = template.defaultVolumeMl
        abvPercent = template.defaultAbv
        drinkingMinutes = template.defaultDrinkingMinutes
    }

    init(templateID: String, volumeMl: Double, abvPercent: Double, drinkingMinutes: Double) {
        self.templateID = templateID
        self.volumeMl = volumeMl
        self.abvPercent = abvPercent
        self.drinkingMinutes = drinkingMinutes
    }

    /// The shape of a drink already logged — what the quick add repeats until a
    /// favourite has been chosen.
    ///
    /// `drinkingMinutes` is taken as recorded rather than reset to the
    /// template's default, and that is safe by construction: the pour cut only
    /// ever shortens a drink that a *later* one interrupted (5.13), and the
    /// drink this is built from is the most recent one there is. A duration
    /// that was cut short can therefore not be copied forward, which is what
    /// would have manufactured a rise steeper than anything that happened.
    init(_ drink: Drink) {
        templateID = drink.name ?? DrinkCatalog.template(for: drink).id
        volumeMl = drink.volumeMl
        abvPercent = drink.abvPercent
        drinkingMinutes = drink.drinkingMinutes
    }

    static let suggestion = FavouriteDrink(DrinkCatalog.all[0])
}

/// Where the quick add got its drink from.
///
/// Worth distinguishing, because only one of the two is something the user
/// said. A repeat is a guess the app is making until it is told otherwise, and
/// it says so — the strip after the add offers to make it the favourite.
enum QuickAddSource: Equatable {
    /// The standing choice from the profile.
    case favourite
    /// The most recent drink on record, because there is no favourite yet.
    case lastDrink
}

/// What the quick-add button is offering right now.
struct QuickAddOffer: Equatable {
    let drink: Drink
    let source: QuickAddSource

    var isFavourite: Bool { source == .favourite }
}

/// What one quick add did.
///
/// Carries the shortening as well as the drink, because logging a drink cuts
/// short the one before it (5.13) and a plain delete does not give that
/// duration back. Everywhere else that is the right rule — the app does not
/// keep a record of defaults it has replaced. Here it keeps one for a few
/// seconds, which is the difference between an undo and an apology.
struct QuickAddReceipt: Identifiable, Equatable {
    let drink: Drink
    let shortened: PourCutRecord?

    /// Where it came from. A repeat is the one case where the strip has
    /// something more to offer than an undo — the drink in front of you is the
    /// best possible moment to ask whether this is the usual one.
    let source: QuickAddSource

    /// One strip per drink: a second quick add replaces the first's strip and
    /// restarts its timer rather than stacking.
    var id: UUID { drink.id }
}

/// A drink that was shortened, and the duration it had before.
struct PourCutRecord: Equatable {
    let drinkID: UUID
    let previousMinutes: Double
}
