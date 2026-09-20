import SwiftUI

/// Writing the whole store to a file, and reading one back.
///
/// Its own view rather than another computed property on `ProfileView`: it owns
/// six pieces of state and four presentations, and folding that into a screen
/// that is otherwise a list of sliders would bury it.
///
/// Placed low on the Profile screen on purpose. Nobody comes to this app to
/// manage backups, and a control that sits higher reads as a step in the
/// ordinary flow.
struct DataTransferSection: View {
    let store: SessionStore

    @State private var document: ArchiveDocument?
    @State private var showsExporter = false
    @State private var showsImporter = false

    /// Set once a file has been read and understood, which is what opens the
    /// confirmation. Nothing is written until the user has seen this.
    @State private var plan: ArchiveImport.Plan?
    @State private var outcome: ArchiveImport.Outcome?
    @State private var failure: ArchiveError?

    var body: some View {
        Section {
            Button {
                // Built at the moment of tapping, not held in state: an archive
                // made when the screen appeared would be stale by the time
                // somebody exported it after logging a drink.
                document = ArchiveDocument(archive: store.archive())
                showsExporter = true
            } label: {
                Label("Export a backup", systemImage: "square.and.arrow.up")
            }

            Button {
                showsImporter = true
            } label: {
                Label("Import a backup", systemImage: "square.and.arrow.down")
            }
        } header: {
            Text("Backup")
        } footer: {
            Text("A backup holds every person, occasion and drink. Importing adds what is missing — it never changes or removes anything already here.")
        }
        .listRowBackground(Theme.surface)
        .tint(Theme.calm)
        .fileExporter(
            isPresented: $showsExporter,
            document: document,
            contentType: .json,
            defaultFilename: ArchiveDocument.suggestedName()
        ) { _ in
            document = nil
        }
        .fileImporter(
            isPresented: $showsImporter,
            allowedContentTypes: [.json]
        ) { result in
            read(result)
        }
        .alert(
            Text("Import this backup?"),
            isPresented: presenting($plan),
            presenting: plan
        ) { plan in
            Button("Import") { apply(plan) }
            Button("Cancel", role: .cancel) {}
        } message: { plan in
            if plan.changesNothing {
                Text("Everything in this backup is already here.")
            } else {
                Text("Adds \(count(plan.sessionsToAdd)) occasions and \(count(plan.drinksToAdd)) drinks. Nothing already here is changed or removed.")
            }
        }
        .alert(
            Text("Import finished"),
            isPresented: presenting($outcome),
            presenting: outcome
        ) { _ in
            Button("OK") {}
        } message: { outcome in
            Text("Added \(count(outcome.sessionsAdded)) occasions and \(count(outcome.drinksAdded)) drinks.")
        }
        .alert(
            Text("Could not import"),
            isPresented: presenting($failure),
            presenting: failure
        ) { _ in
            Button("OK") {}
        } message: { failure in
            Text(failure.message)
        }
    }

    // MARK: Actions

    /// Reads the chosen file and works out what it would do — but does not do
    /// it. The confirmation needs numbers, and numbers need the file.
    private func read(_ result: Result<URL, Error>) {
        guard case .success(let url) = result else { return }

        // A file picked from Files or iCloud Drive lives outside this app's
        // container, and is only readable while the scoped access is held.
        let scoped = url.startAccessingSecurityScopedResource()
        defer { if scoped { url.stopAccessingSecurityScopedResource() } }

        do {
            plan = store.importPlan(for: try DataArchive.decoded(from: try Data(contentsOf: url)))
        } catch let error as ArchiveError {
            failure = error
        } catch {
            failure = .unreadable
        }
    }

    private func apply(_ plan: ArchiveImport.Plan) {
        outcome = store.importArchive(plan)
    }

    // MARK: Helpers

    /// An optional as a presentation binding: showing while it holds something,
    /// and clearing it when the alert is dismissed. Without the clear, the same
    /// alert could never be shown twice.
    private func presenting<T>(_ value: Binding<T?>) -> Binding<Bool> {
        Binding(
            get: { value.wrappedValue != nil },
            set: { if !$0 { value.wrappedValue = nil } }
        )
    }

    /// Formatted here rather than interpolated raw, so the count is localized
    /// and the format specifier stays `%@` (7.).
    private func count(_ value: Int) -> String {
        value.formatted(.number)
    }
}
