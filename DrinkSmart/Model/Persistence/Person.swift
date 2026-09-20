import Foundation
import SwiftData
import BACKit

/// Someone whose drinking this app records.
///
/// There is always exactly one owner — you — and the app behaves as it always
/// did until a second person exists. A guest is a full person, not a reduced
/// one: the curve is a function of sex, age, height and weight, so a "quick
/// profile" with half of those would produce a curve that is simply wrong,
/// which is worse than no curve at all.
///
/// ## What lives here and what does not
///
/// Everything that describes a *person* — body, elimination rate, personal
/// limit, when their records start. What stays in `AppSettings` is what
/// describes the *device*: the unit the figures are shown in, and which person
/// is currently active.
///
/// The session's profile snapshot (`DrinkingSession`, 5.5) is unaffected and
/// still the record of who someone was *then*. This type is who they are now.
///
/// ## CloudKit constraints
///
/// Every property has a default value, nothing is unique, and the relationship
/// is optional with an inverse — the same rules `DrinkingSession` follows.
@Model
final class Person {

    /// The id a session carries before it has been assigned to anyone.
    ///
    /// A sentinel rather than an optional `personID`, because a plain scalar is
    /// what `#Predicate` handles reliably, and "not yet assigned" is a state
    /// the migration has to be able to query for.
    static let unassignedID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    var id: UUID = UUID()

    /// Empty for the owner, who is shown as "You" rather than under a name
    /// they never typed.
    var name: String = ""

    /// Exactly one person is the owner: the one the app started with. It
    /// cannot be deleted, and the active person falls back to it.
    var isOwner: Bool = false

    var createdAt: Date = Date.now

    /// Which accent the switcher chip uses. Only the chip — the curve stays
    /// tinted by level against the limit (5.14).
    var accentRaw: String = PersonAccent.teal.rawValue

    // MARK: Body
    //
    // Flattened for the same reason `DrinkingSession` flattens its snapshot:
    // CloudKit prefers scalars, and a diff shows what actually changed.

    var sexRaw: String = Sex.male.rawValue
    var age: Double = 35
    var heightCm: Double = 180
    var weightKg: Double = 80
    var beta: Double = Physiology.defaultBeta
    var betaUncertainty: Double = Physiology.defaultBetaUncertainty

    /// The frequency question that stands in for beta (5.3). Stored rather
    /// than derived from beta, because a rate set by hand in the advanced
    /// section should not silently rewrite the answer the user gave.
    var frequencyRaw: String = DrinkingFrequency.occasional.rawValue

    /// This person's limit in g/L. Not a legal limit.
    var limit: Double = 0.8

    /// When this person's records start. Before it, an empty day means we do
    /// not know; after it, it means they did not drink (5.7).
    var trackingStartedAt: Date = Date.now

    // MARK: The quick-add favourite
    //
    // On the person rather than in `AppSettings`, and the split is the same one
    // that governs everything else here: what someone usually orders describes
    // them, not the device they happen to be holding. A guest does not drink
    // the owner's pint, and a new phone should arrive knowing the answer —
    // which it will, because this side syncs and `AppSettings` deliberately
    // does not.
    //
    // Not behind `Feature.multiPerson` or any other flag: a flag must never
    // gate the schema (11.5). Flat fields rather than one encoded blob, for the
    // reason `DrinkingSession` flattens its snapshot — CloudKit prefers
    // scalars, and a diff then shows what actually changed.

    /// `nil` means no favourite has been chosen, and the quick-add button does
    /// not appear at all.
    ///
    /// Optional rather than defaulted to beer: a favourite nobody picked would
    /// put a drink this person may never order one tap away, which is exactly
    /// the kind of silent assertion the app avoids everywhere else.
    var favouriteTemplateID: String?

    /// Only meaningful while `favouriteTemplateID` is non-nil. Defaulted rather
    /// than optional because three more optionals would buy nothing: they are
    /// never read without the identifier.
    var favouriteVolumeMl: Double = 0
    var favouriteAbvPercent: Double = 0
    var favouriteDrinkingMinutes: Double = 0

    @Relationship(deleteRule: .cascade, inverse: \DrinkingSession.person)
    var sessions: [DrinkingSession]? = []

    init(
        id: UUID = UUID(),
        name: String = "",
        isOwner: Bool = false,
        createdAt: Date = .now,
        accent: PersonAccent = .teal,
        profile: BodyProfile,
        frequency: DrinkingFrequency,
        limit: Double,
        trackingStartedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.isOwner = isOwner
        self.createdAt = createdAt
        self.accentRaw = accent.rawValue
        self.frequencyRaw = frequency.rawValue
        self.limit = limit
        self.trackingStartedAt = trackingStartedAt
        self.sessions = []
        apply(profile)
    }

    // MARK: Profile

    /// Note that `totalBodyWaterOverride` is not stored, exactly as it is not
    /// stored on a session: nothing sets it yet, and a persisted field with no
    /// writer is a field that rots.
    var profile: BodyProfile {
        BodyProfile(
            sex: Sex(rawValue: sexRaw) ?? .male,
            age: age,
            heightCm: heightCm,
            weightKg: weightKg,
            beta: beta,
            betaUncertainty: betaUncertainty
        )
    }

    func apply(_ profile: BodyProfile) {
        sexRaw = profile.sex.rawValue
        age = profile.age
        heightCm = profile.heightCm
        weightKg = profile.weightKg
        beta = profile.beta
        betaUncertainty = profile.betaUncertainty
    }

    var frequency: DrinkingFrequency {
        get { DrinkingFrequency(rawValue: frequencyRaw) ?? .closest(toBeta: beta) }
        set {
            frequencyRaw = newValue.rawValue
            var updated = profile
            newValue.apply(to: &updated)   // sets beta, leaves uncertainty alone
            apply(updated)
        }
    }

    var accent: PersonAccent {
        get { PersonAccent(rawValue: accentRaw) ?? .teal }
        set { accentRaw = newValue.rawValue }
    }

    /// The quick-add favourite, or nil if there is none.
    ///
    /// Setting nil clears the identifier and leaves the numbers where they
    /// were. They are dead weight until a favourite exists again, and wiping
    /// them would mean that turning the button back on starts from the template
    /// defaults rather than from what was last chosen.
    var favourite: FavouriteDrink? {
        get {
            guard let favouriteTemplateID else { return nil }
            return FavouriteDrink(
                templateID: favouriteTemplateID,
                volumeMl: favouriteVolumeMl,
                abvPercent: favouriteAbvPercent,
                drinkingMinutes: favouriteDrinkingMinutes
            )
        }
        set {
            favouriteTemplateID = newValue?.templateID
            guard let newValue else { return }
            favouriteVolumeMl = newValue.volumeMl
            favouriteAbvPercent = newValue.abvPercent
            favouriteDrinkingMinutes = newValue.drinkingMinutes
        }
    }

    // MARK: Presentation

    /// Nil for the owner, who is shown as a localized "You". Inventing a
    /// stored name for them would put a value nobody typed into a text field —
    /// and a name is not a localizable string, so the two cannot be one
    /// property.
    var displayName: String? {
        name.isEmpty ? nil : name
    }

    /// One or two letters for the switcher chip.
    var monogram: String {
        let initials = name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
        return initials.isEmpty ? "•" : initials.uppercased()
    }

    /// Moves the start of records earlier, never later — a drink that predates
    /// it is evidence we were already keeping records then.
    func backdateTracking(to date: Date) {
        guard date < trackingStartedAt else { return }
        trackingStartedAt = date
    }
}

/// The colours a person can be tagged with in the switcher.
///
/// A closed set rather than a free colour picker: these have to stay legible
/// on the dark surface, and they must not be mistaken for the level colours,
/// which mean something (5.14).
enum PersonAccent: String, CaseIterable, Identifiable, Codable {
    case teal, violet, amber, rose, sky

    var id: String { rawValue }
}
