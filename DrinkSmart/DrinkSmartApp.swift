import SwiftUI
import SwiftData

@main
@MainActor
struct DrinkSmartApp: App {
    private let container: ModelContainer
    @State private var store: SessionStore

    init() {
        let container = Self.makeContainer()
        self.container = container

        // Built here rather than inside a view, so the context is available
        // immediately and the store is created exactly once.
        let settings = AppSettings()
        _store = State(initialValue: SessionStore(context: container.mainContext, settings: settings))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(store: store)
        }
        .modelContainer(container)
    }

    /// Builds the store, falling back to local-only if CloudKit is not usable.
    ///
    /// Syncing needs the iCloud capability with CloudKit, and Background Modes
    /// with remote notifications, enabled on the target in Xcode. Until that is
    /// set up the container would fail to open — and an app that will not
    /// launch is a worse outcome than one that does not sync yet. So we try
    /// CloudKit, and on failure open the same store without it.
    ///
    /// The fallback is not silent for the developer: it trips an assertion in
    /// debug builds.
    private static func makeContainer() -> ModelContainer {
        let schema = Schema([Person.self, DrinkingSession.self, DrinkRecord.self])

        do {
            return try ModelContainer(
                for: schema,
                configurations: ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)
            )
        } catch {
            assertionFailure("CloudKit container unavailable, falling back to local: \(error)")
        }

        do {
            return try ModelContainer(
                for: schema,
                configurations: ModelConfiguration(schema: schema, cloudKitDatabase: .none)
            )
        } catch {
            // Nothing sensible is left to do: the app's entire purpose is to
            // record drinks, and it cannot.
            fatalError("Could not open the data store: \(error)")
        }
    }
}
