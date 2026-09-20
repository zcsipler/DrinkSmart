import SwiftUI
import UniformTypeIdentifiers

/// Wraps a `DataArchive` so `.fileExporter` can write it out.
///
/// Typed as plain `.json` rather than a custom UTI. A private type would look
/// tidier in the share sheet, but it has to be declared in the Info.plist, and
/// it would stop every other app from opening the file — for a backup whose
/// whole purpose is to leave this app, that is the wrong trade. The version
/// lives inside the file (`schemaVersion`), which is where it can actually be
/// checked.
///
/// Export only. The import side uses `.fileImporter`, which hands over a URL
/// and lets a bad file produce a message the user can act on, rather than a
/// document that silently fails to initialise.
struct ArchiveDocument: FileDocument {

    static var readableContentTypes: [UTType] { [.json] }

    var archive: DataArchive

    init(archive: DataArchive) {
        self.archive = archive
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw ArchiveError.unreadable
        }
        archive = try DataArchive.decoded(from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: try archive.encoded())
    }

    /// Dated, so a folder of them sorts and reads sensibly. No extension: the
    /// exporter appends one from the content type.
    static func suggestedName(for date: Date = .now) -> String {
        let formatted = date.formatted(
            .iso8601.year().month().day().dateSeparator(.dash)
        )
        return "DrinkSmart-\(formatted)"
    }
}
