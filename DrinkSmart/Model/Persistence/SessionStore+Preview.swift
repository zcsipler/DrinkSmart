import Foundation
import SwiftData
import BACKit

extension SessionStore {

    /// An in-memory store with one session in progress, for SwiftUI previews.
    ///
    /// Separate from the production path on purpose: previews must never touch
    /// the real database, and the legacy import must never run against sample
    /// data.
    @MainActor
    static var preview: SessionStore {
        let schema = Schema([DrinkingSession.self, DrinkRecord.self])
        let container = try! ModelContainer(
            for: schema,
            configurations: ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true,
                cloudKitDatabase: .none
            )
        )

        let settings = AppSettings()
        let store = SessionStore(context: container.mainContext, settings: settings)

        // `name` carries the template identifier, not the displayed name.
        let samples = [
            Drink(consumedAt: .now.addingTimeInterval(-9000), volumeMl: 500, abvPercent: 5, stomach: .full, name: "beer"),
            Drink(consumedAt: .now.addingTimeInterval(-5400), volumeMl: 500, abvPercent: 5, stomach: .light, name: "beer"),
            Drink(consumedAt: .now.addingTimeInterval(-2700), volumeMl: 150, abvPercent: 12, stomach: .light, name: "wine"),
            Drink(consumedAt: .now.addingTimeInterval(-900), volumeMl: 40, abvPercent: 40, stomach: .light, name: "spirit"),
        ]
        for drink in samples {
            store.add(drink)
        }

        return store
    }
}
