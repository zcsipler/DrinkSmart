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

    /// The CloudKit container this app syncs through.
    ///
    /// Named explicitly rather than left to `.automatic`, and that is the whole
    /// point. `.automatic` means "mirror to whichever container the entitlement
    /// grants, **if** it grants one" — with no iCloud entitlement it opens a
    /// plain local store and does not throw. The `catch` below then never runs,
    /// the assertion never trips, and the app reports success while syncing
    /// nothing. That is exactly how this went unnoticed: it looked like it
    /// worked on a build that had no CloudKit at all.
    ///
    /// Naming the container makes the failure real. A missing entitlement, a
    /// typo here, a container the signing team does not own — all of it throws,
    /// which is what the fallback was written for.
    private static let cloudKitContainerID = "iCloud.dev.zcsipler.drinksmart"

    /// Builds the store: with CloudKit when the build is provisioned for it,
    /// local-only otherwise.
    ///
    /// Two different situations, deliberately told apart.
    ///
    /// `BuildCapabilities.cloudSync` off means the target has no iCloud
    /// capability *and we know it* — there is nothing to warn about, so the
    /// local store is opened directly and the app behaves as it always has.
    ///
    /// With it on, a failure is a real problem: the entitlement is missing, the
    /// container identifier is wrong, or the signing team does not own it. Then
    /// the fallback keeps the app running — an app that will not launch is a
    /// worse outcome than one that does not sync — but trips an assertion, so a
    /// debug build says so instead of pretending.
    private static func makeContainer() -> ModelContainer {
        let schema = Schema([Person.self, DrinkingSession.self, DrinkRecord.self])

        if BuildCapabilities.cloudSync {
            do {
                return try ModelContainer(
                    for: schema,
                    configurations: ModelConfiguration(
                        schema: schema,
                        cloudKitDatabase: .private(cloudKitContainerID)
                    )
                )
            } catch {
                assertionFailure("CloudKit container unavailable, falling back to local: \(error)")
            }
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
