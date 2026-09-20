import Foundation
import SwiftData
import Testing
import BACKit
@testable import DrinkSmart

/// An in-memory database with the app's real schema.
///
/// Never CloudKit and never on disk: a test that touches the developer's own
/// history is a test nobody dares run twice.
@MainActor
func makeContext() throws -> ModelContext {
    let schema = Schema([Person.self, DrinkingSession.self, DrinkRecord.self])
    let container = try ModelContainer(
        for: schema,
        configurations: ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
            cloudKitDatabase: .none
        )
    )
    return ModelContext(container)
}

/// A store on a fresh database, with settings that write to a throwaway
/// defaults suite so nothing leaks into the next test.
@MainActor
func makeStore() throws -> SessionStore {
    let defaults = UserDefaults(suiteName: "drinksmart.tests.\(UUID().uuidString)")!
    return SessionStore(context: try makeContext(), settings: AppSettings(defaults: defaults))
}

@MainActor
@discardableResult
func makeGuest(
    in context: ModelContext,
    name: String = "Guest",
    weightKg: Double = 58
) -> Person {
    let guest = Person(
        name: name,
        profile: BodyProfile(sex: .female, age: 29, heightCm: 166, weightKg: weightKg),
        frequency: .occasional,
        limit: 0.8
    )
    context.insert(guest)
    return guest
}

extension BodyProfile {
    /// One fixed body, so a test that is not about the profile never depends
    /// on one.
    static let test = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
}

extension Drink {
    /// A half-litre 5 % beer, the app's most ordinary input.
    static func beer(at date: Date) -> Drink {
        Drink(consumedAt: date, volumeMl: 500, abvPercent: 5, stomach: .light, drinkingMinutes: 30)
    }
}
