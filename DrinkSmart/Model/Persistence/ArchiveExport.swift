import Foundation
import SwiftData

/// Reads the whole store into a `DataArchive`.
///
/// Everyone and every occasion, not just the active person: an export the user
/// has to repeat once per person is an export that will be incomplete when it
/// matters.
enum ArchiveExport {

    static func archive(from context: ModelContext, at date: Date = .now) -> DataArchive {
        DataArchive(
            exportedAt: date,
            people: people(in: context),
            sessions: sessions(in: context)
        )
    }

    private static func people(in context: ModelContext) -> [ArchivedPerson] {
        let descriptor = FetchDescriptor<Person>(sortBy: [SortDescriptor(\.createdAt)])
        let stored = (try? context.fetch(descriptor)) ?? []

        return stored.map { person in
            ArchivedPerson(
                id: person.id,
                name: person.name,
                isOwner: person.isOwner,
                createdAt: person.createdAt,
                accentRaw: person.accentRaw,
                sexRaw: person.sexRaw,
                age: person.age,
                heightCm: person.heightCm,
                weightKg: person.weightKg,
                beta: person.beta,
                betaUncertainty: person.betaUncertainty,
                frequencyRaw: person.frequencyRaw,
                limit: person.limit,
                trackingStartedAt: person.trackingStartedAt
            )
        }
    }

    private static func sessions(in context: ModelContext) -> [ArchivedSession] {
        let descriptor = FetchDescriptor<DrinkingSession>(sortBy: [SortDescriptor(\.startedAt)])
        let stored = (try? context.fetch(descriptor)) ?? []

        return stored.map { session in
            ArchivedSession(
                id: session.id,
                startedAt: session.startedAt,
                endedAt: session.endedAt,
                sexRaw: session.sexRaw,
                age: session.age,
                heightCm: session.heightCm,
                weightKg: session.weightKg,
                beta: session.beta,
                betaUncertainty: session.betaUncertainty,
                limit: session.limit,
                personID: session.personID,
                drinks: drinks(of: session)
            )
        }
    }

    /// Sorted by time rather than left in the relationship's order, which is
    /// unspecified — a file that reorders itself between two exports of the
    /// same data is a file nobody can diff.
    private static func drinks(of session: DrinkingSession) -> [ArchivedDrink] {
        (session.drinks ?? [])
            .sorted { $0.consumedAt < $1.consumedAt }
            .map { record in
                ArchivedDrink(
                    id: record.id,
                    consumedAt: record.consumedAt,
                    volumeMl: record.volumeMl,
                    abvPercent: record.abvPercent,
                    drinkingMinutes: record.drinkingMinutes,
                    stomachRaw: record.stomachRaw,
                    templateID: record.templateID
                )
            }
    }
}
