import Foundation
import BACKit

/// The shape `AppSettings` wrote before the profile moved onto `Person`.
///
/// A standalone decoder, for the same reason `LegacySessionSnapshot` is one:
/// decoding old data against a type that is still moving is how migrations
/// quietly lose rows. Nothing writes this key any more — it is read once, by
/// `PersonMigration`, and then left alone. It is not deleted, because it is
/// the only copy of the profile that predates the database, and an import that
/// turns out wrong should be redoable from the original.
struct LegacyProfileSettings: Codable {
    var profile: BodyProfile
    var limit: Double
    var unit: BACUnit
    var frequency: DrinkingFrequency
    /// Optional so a snapshot written before this existed still decodes.
    var trackingStartedAt: Date?

    static let storageKey = "drinksmart.settings.v1"

    /// `defaults` is injectable so a test can hand over a throwaway suite
    /// instead of writing into the app's real settings.
    static func stored(in defaults: UserDefaults = .standard) -> LegacyProfileSettings? {
        guard let data = defaults.data(forKey: storageKey) else { return nil }
        return try? JSONDecoder().decode(LegacyProfileSettings.self, from: data)
    }
}
