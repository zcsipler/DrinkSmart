import Foundation

/// Everything the app knows, in a form that survives outside it.
///
/// ## Why this exists
///
/// CloudKit (11.4) covers the ordinary case: same Apple ID, new phone, the data
/// is already there. It does not cover the rest, and the rest is not exotic.
///
/// - **iCloud is not a backup.** A user who clears the app's iCloud data in
///   Settings has cleared it everywhere. There is no bin to recover from.
/// - **Not everyone syncs.** Signed out of iCloud, or iCloud Drive off, and the
///   local fallback in `DrinkSmartApp.makeContainer` is the whole story. For
///   those users this file is the only way to move anything.
/// - **Apple ID changes happen**, and CloudKit has nothing to say about them.
/// - **A migration can go wrong**, and a CloudKit schema cannot be rolled back
///   once it is deployed to production — only extended.
/// - **Portability** (GDPR art. 20). For a record of someone's drinking, being
///   able to take it away is not a formality.
///
/// ## Why JSON and not a copy of the store
///
/// Copying the `.sqlite` is tempting and wrong: it carries SwiftData and
/// CloudKit bookkeeping, and nothing guarantees a future version can open it.
/// JSON is readable, diffable, and carries its own version.
///
/// ## What is in it, and what is not
///
/// The same principle as the session snapshot (5.5): **the input is stored, not
/// the curve.** Drinks and the profile they were recorded against are enough to
/// redraw everything, and a later improvement to the engine then applies to
/// imported history as well.
///
/// So the cached summary — `cachedPeakLow`, `cachedSoberAt`,
/// `cachedEngineVersion` and the rest — is deliberately absent. It is
/// recomputable, it is tied to `BACEngine.version`, and carried into a build
/// with a different engine it would state figures that build never produced.
/// `AppSettings` is absent for a different reason: it describes the device, not
/// the person (see its own note).
struct DataArchive: Codable, Equatable {

    /// Bumped when the shape changes in a way an older build cannot read.
    ///
    /// The import refuses anything newer than it knows, rather than decoding
    /// what it recognizes and silently dropping the rest.
    static let currentVersion = 1

    var schemaVersion: Int
    var exportedAt: Date
    var people: [ArchivedPerson]
    var sessions: [ArchivedSession]

    init(
        schemaVersion: Int = DataArchive.currentVersion,
        exportedAt: Date = .now,
        people: [ArchivedPerson],
        sessions: [ArchivedSession]
    ) {
        self.schemaVersion = schemaVersion
        self.exportedAt = exportedAt
        self.people = people
        self.sessions = sessions
    }

    var drinkCount: Int {
        sessions.reduce(0) { $0 + $1.drinks.count }
    }

    // MARK: Reading and writing
    //
    // ISO 8601 rather than the default `Double` since-reference-date: a date in
    // an archive is read by people, and a support conversation about "which
    // evening is 748305600" is one nobody should have.

    static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }

    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func encoded() throws -> Data {
        try Self.makeEncoder().encode(self)
    }

    /// - Throws: `ArchiveError.unreadable` for anything that is not an archive,
    ///   `ArchiveError.tooNew` for one this build cannot be trusted to read.
    static func decoded(from data: Data) throws -> DataArchive {
        let archive: DataArchive
        do {
            archive = try makeDecoder().decode(DataArchive.self, from: data)
        } catch {
            throw ArchiveError.unreadable
        }

        guard archive.schemaVersion <= currentVersion else {
            throw ArchiveError.tooNew(found: archive.schemaVersion)
        }
        return archive
    }
}

/// A person, flattened exactly as `Person` stores them.
///
/// The enums travel as their raw strings, for the same reason the model stores
/// them that way: a value this build has never seen must still decode to
/// something rather than failing the whole file.
struct ArchivedPerson: Codable, Equatable {
    var id: UUID
    var name: String
    var isOwner: Bool
    var createdAt: Date
    var accentRaw: String

    var sexRaw: String
    var age: Double
    var heightCm: Double
    var weightKg: Double
    var beta: Double
    var betaUncertainty: Double

    var frequencyRaw: String
    var limit: Double
    var trackingStartedAt: Date

    /// The quick-add favourite. Optional throughout, and that is what keeps
    /// `schemaVersion` at 1: an archive written before this existed decodes to
    /// nil rather than throwing, and an older build reading a newer file simply
    /// ignores keys it does not know. The version is for changes an older build
    /// cannot read, and this is not one.
    var favouriteTemplateID: String?
    var favouriteVolumeMl: Double?
    var favouriteAbvPercent: Double?
    var favouriteDrinkingMinutes: Double?

    var favourite: FavouriteDrink? {
        guard let favouriteTemplateID else { return nil }
        return FavouriteDrink(
            templateID: favouriteTemplateID,
            volumeMl: favouriteVolumeMl ?? 0,
            abvPercent: favouriteAbvPercent ?? 0,
            drinkingMinutes: favouriteDrinkingMinutes ?? 0
        )
    }
}

/// One occasion, with its frozen profile and its drinks.
///
/// Drinks are nested rather than kept in a flat list with a foreign key: the
/// relationship is then impossible to get wrong, and the file reads as what it
/// is — a list of evenings.
struct ArchivedSession: Codable, Equatable {
    var id: UUID
    var startedAt: Date
    var endedAt: Date?

    var sexRaw: String
    var age: Double
    var heightCm: Double
    var weightKg: Double
    var beta: Double
    var betaUncertainty: Double

    var limit: Double
    var personID: UUID

    var drinks: [ArchivedDrink]
}

struct ArchivedDrink: Codable, Equatable {
    var id: UUID
    var consumedAt: Date
    var volumeMl: Double
    var abvPercent: Double
    var drinkingMinutes: Double
    var stomachRaw: String
    var templateID: String
}

/// Why an archive could not be used.
///
/// Distinguished because the answers differ: a wrong file is the user's mistake
/// to correct, a newer file means their other device is ahead of this one.
enum ArchiveError: Error, Equatable {
    case unreadable
    case tooNew(found: Int)

    var message: LocalizedStringResource {
        switch self {
        case .unreadable:
            "This file is not a DrinkSmart backup, or it is damaged."
        case .tooNew:
            "This backup was made by a newer version of DrinkSmart. Update the app and try again."
        }
    }
}
