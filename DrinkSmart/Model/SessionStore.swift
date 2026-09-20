import Foundation
import Observation
import SwiftData
import BACKit

/// State for the current drinking session.
///
/// Backed by SwiftData: the open `DrinkingSession` is the source of truth, and
/// the band is derived from it. Settings live in `AppSettings`, because they
/// describe the user now, whereas the session records who they were then.
///
/// The band is recomputed only when an input actually changes. The clock tick
/// moves `now`, which refreshes the readout without starting a simulation.
/// Main-actor isolated: it holds a `ModelContext`, which is not `Sendable`,
/// and every caller is a view anyway.
@Observable
@MainActor
final class SessionStore {

    private let context: ModelContext
    private let engine = BACEngine()
    let settings: AppSettings

    /// The app's own person. Always exists, never deleted.
    private(set) var owner: Person

    /// Whose drinks are being recorded and shown. The owner unless someone
    /// switched, and the owner again from the next drinking day (5.6) —
    /// see `AppSettings.activePersonIDIfCurrent`.
    private(set) var person: Person

    /// The session currently accepting drinks. Nil until the first one.
    private(set) var session: DrinkingSession?

    private(set) var band: BACBand = .empty

    /// The current time. Refreshed every half minute.
    var now: Date = .now

    init(context: ModelContext, settings: AppSettings) {
        self.context = context
        self.settings = settings
        LegacySessionImport.run(in: context)

        // Before anything reads a session: until this has run, sessions exist
        // that belong to nobody, and every query below filters on a person.
        let owner = PersonMigration.run(in: context)
        self.owner = owner
        self.person = owner

        restoreActivePerson()
        refreshFromStore()
    }

    // MARK: People

    /// Owner first, then in the order they were added.
    ///
    /// Sorted in memory because `Bool` is not `Comparable` and a
    /// `SortDescriptor` cannot express "owner first"; the list is a handful of
    /// rows, so this costs nothing.
    var people: [Person] {
        let all = (try? context.fetch(FetchDescriptor<Person>())) ?? []
        return all.sorted { lhs, rhs in
            if lhs.isOwner != rhs.isOwner { return lhs.isOwner }
            return lhs.createdAt < rhs.createdAt
        }
    }

    /// Switches who is being recorded. Everything else follows: the open
    /// session, the curve, the profile the settings screen edits.
    func activate(_ next: Person) {
        guard next.id != person.id else { return }
        person = next

        if next.id == owner.id {
            settings.clearActivePerson()
        } else {
            settings.setActivePerson(next.id, at: now)
        }

        refreshFromStore()
    }

    /// Adds someone and switches to them: you add a person in order to record
    /// their next drink, not to admire the list.
    @discardableResult
    func addPerson(
        name: String,
        profile: BodyProfile,
        frequency: DrinkingFrequency,
        limit: Double
    ) -> Person {
        let new = Person(
            name: name,
            accent: nextAccent(),
            profile: profile,
            frequency: frequency,
            limit: limit
        )
        context.insert(new)
        save()
        activate(new)
        return new
    }

    /// The first colour nobody is using, so two people are told apart at a
    /// glance without anyone being asked to pick a colour in a bar.
    private func nextAccent() -> PersonAccent {
        let taken = Set(people.map(\.accent))
        return PersonAccent.allCases.first { !taken.contains($0) } ?? .teal
    }

    /// Restores the choice made earlier this evening, and lets it lapse
    /// otherwise. A person deleted on another device leaves a dangling id;
    /// that falls back to the owner too.
    private func restoreActivePerson() {
        guard
            let id = settings.activePersonIDIfCurrent(at: now),
            id != owner.id,
            let stored = fetchPerson(id)
        else {
            settings.clearActivePerson()
            person = owner
            return
        }
        person = stored
    }

    private func fetchPerson(_ id: UUID) -> Person? {
        var descriptor = FetchDescriptor<Person>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    // MARK: Settings passthrough
    //
    // The views talk to the store; whether a value belongs to the person, the
    // device or the session is not their concern.

    var profile: BodyProfile {
        get { person.profile }
        set {
            person.apply(newValue)
            // An open session follows the current profile: a correction made
            // mid-evening should fix the curve you are looking at. A closed
            // one never moves.
            session?.applySnapshot(of: newValue)
            save()
            rebuild()
        }
    }

    var limit: Double {
        get { person.limit }
        set {
            person.limit = newValue
            session?.limit = newValue
            save()
        }
    }

    var unit: BACUnit {
        get { settings.unit }
        set { settings.unit = newValue }
    }

    var frequency: DrinkingFrequency {
        get { person.frequency }
        set {
            person.frequency = newValue   // rewrites beta, leaves uncertainty
            session?.applySnapshot(of: person.profile)
            save()
            rebuild()
        }
    }

    // MARK: Session lifecycle

    /// Loads the active person's open session, and closes whatever has ended.
    ///
    /// Called on launch and when returning to the foreground, not only when a
    /// drink is logged — otherwise a forgotten session would stay open for days.
    func refreshFromStore() {
        closeEndedSessions()
        session = fetchOpenSession()
        rebuild()
    }

    private func fetchOpenSession() -> DrinkingSession? {
        let personID = person.id
        var descriptor = FetchDescriptor<DrinkingSession>(
            predicate: #Predicate { $0.endedAt == nil && $0.personID == personID },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    /// Runs the closing policy over **every** open session, not just the
    /// active person's.
    ///
    /// With one person this was the same thing. With two it is not: a guest's
    /// evening would stay open forever, because nothing would ever look at it
    /// again unless somebody switched back to her — and a session that never
    /// closes never reaches History and never gets its summary.
    private func closeEndedSessions() {
        let descriptor = FetchDescriptor<DrinkingSession>(
            predicate: #Predicate { $0.endedAt == nil }
        )
        let open = (try? context.fetch(descriptor)) ?? []

        var closedAny = false
        for candidate in open where close(candidate) { closedAny = true }
        if closedAny { save() }
    }

    /// Closes the active person's session if the policy says it has ended.
    private func closeSessionIfEnded() {
        guard let session else { return }
        if close(session) { save() }
    }

    /// - Returns: whether the session was closed.
    private func close(_ target: DrinkingSession) -> Bool {
        let drinks = target.sortedDrinks
        guard !drinks.isEmpty else { return false }

        let computed = engine.simulateBand(profile: target.profile, drinks: drinks)
        let lastDrinkAt = drinks.last?.consumedAt

        guard !SessionPolicy.isStillOpen(band: computed, lastDrinkAt: lastDrinkAt, at: now) else {
            return false
        }

        target.endedAt = SessionPolicy.closingDate(
            lastDrinkAt: lastDrinkAt,
            soberAt: computed.soberRange()?.upperBound
        )
        target.store(summary(for: target, band: computed))
        if target === session { session = nil }
        return true
    }

    /// The session a drink at this time belongs to, if one exists.
    ///
    /// Membership follows the drinking day, the same rule the Live screen uses
    /// to group days — so a drink logged late lands where the user would look
    /// for it, rather than wherever the open session happens to be.
    ///
    /// Scoped to the active person: two people out on the same evening have two
    /// sessions on the same drinking day, and without the filter a backdated
    /// drink would land in whichever was found first.
    private func sessionCovering(_ date: Date) -> DrinkingSession? {
        let day = DrinkingDay.containing(date)

        if let session, day.contains(session.startedAt) { return session }

        return sessionsOfActivePerson().first { day.contains($0.startedAt) }
    }

    /// Newest first.
    private func sessionsOfActivePerson() -> [DrinkingSession] {
        let personID = person.id
        let descriptor = FetchDescriptor<DrinkingSession>(
            predicate: #Predicate { $0.personID == personID },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    private func startSession(at date: Date) -> DrinkingSession {
        let new = DrinkingSession(
            startedAt: date,
            person: person,
            profile: profileApplicable(at: date),
            limit: person.limit
        )
        context.insert(new)
        return new
    }

    /// Which profile a backdated session should freeze.
    ///
    /// For a drink being logged now, today's profile is right. For one being
    /// filled in from six months ago it is not: the whole reason sessions
    /// carry a snapshot is that bodies change. The nearest session in time is
    /// the closest thing we have to who you were then; the current profile is
    /// only the fallback when there is nothing to go on.
    ///
    /// Only the active person's sessions count. Falling back to somebody
    /// else's nearest evening would freeze *their* body into *your* session and
    /// draw a curve for a night that never happened.
    private func profileApplicable(at date: Date) -> BodyProfile {
        let day = DrinkingDay.containing(date)
        guard !day.isCurrent(at: now) else { return person.profile }

        let nearest = sessionsOfActivePerson().min {
            abs($0.startedAt.timeIntervalSince(date)) < abs($1.startedAt.timeIntervalSince(date))
        }
        return nearest?.profile ?? person.profile
    }

    /// Re-decides whether a session is still running, after it has changed.
    ///
    /// A backdated drink can revive a session that had ended, or leave an
    /// older one closed but with a later clearing time. Both go through the
    /// same policy as everything else.
    private func reconcile(_ target: DrinkingSession) {
        let drinks = target.sortedDrinks
        guard !drinks.isEmpty else { return }

        let computed = engine.simulateBand(profile: target.profile, drinks: drinks)
        let lastDrinkAt = drinks.last?.consumedAt

        if SessionPolicy.isStillOpen(band: computed, lastDrinkAt: lastDrinkAt, at: now) {
            target.endedAt = nil
            session = target
        } else {
            target.endedAt = SessionPolicy.closingDate(
                lastDrinkAt: lastDrinkAt,
                soberAt: computed.soberRange()?.upperBound
            )
            target.store(summary(for: target, band: computed))
            if session === target { session = nil }
        }
    }

    // MARK: Derived values

    var drinks: [Drink] { session?.sortedDrinks ?? [] }

    var currentRange: ClosedRange<Double> {
        drinks.isEmpty ? 0...0 : band.range(at: now)
    }

    /// The centre value, for tinting and animation where one number is needed.
    var currentBAC: Double {
        drinks.isEmpty ? 0 : band.value(at: now)
    }

    var peakRange: ClosedRange<Double>? { band.peakRange }
    var peak: BACSample? { band.peak }

    var upcomingPeak: BACSample? {
        guard let peak, peak.date > now.addingTimeInterval(60) else { return nil }
        return peak
    }

    var soberRange: ClosedRange<Date>? {
        drinks.isEmpty ? nil : band.soberRange()
    }

    var sessionStart: Date? { drinks.map(\.consumedAt).min() }

    var sessionDuration: TimeInterval {
        guard let start = sessionStart else { return 0 }
        return max(now.timeIntervalSince(start), 0)
    }

    var totalUnits: Double {
        drinks.reduce(0) { $0 + $1.standardUnits }
    }

    var limitOutcome: LimitOutcome {
        guard !drinks.isEmpty else { return .below }
        let range = currentRange
        if range.lowerBound >= limit { return .above }
        if range.upperBound >= limit { return .uncertain }
        return .below
    }

    /// Whether the curve is rising. The absorption limb is where a breathalyser
    /// would read low.
    var isRising: Bool { !drinks.isEmpty && currentRate > 0.01 }

    var currentRate: Double {
        band.center.samples.last { $0.date <= now }?.rate ?? 0
    }

    var visibleRange: ClosedRange<Date> {
        let start = (sessionStart ?? now).addingTimeInterval(-15 * 60)
        let naturalEnd = soberRange?.upperBound ?? now.addingTimeInterval(4 * 3600)
        let end = max(naturalEnd.addingTimeInterval(20 * 60), start.addingTimeInterval(6 * 3600))
        return start...end
    }

    var yMaximum: Double {
        max((peakRange?.upperBound ?? 0) * 1.3, limit * 1.4, 0.5)
    }

    // MARK: Actions

    /// Logs a drink, including one backdated to a day long past.
    ///
    /// The drink goes to the session covering its own drinking day, not to
    /// whichever session happens to be open. Without that, filling in a beer
    /// from three weeks ago would drag tonight's session back three weeks and
    /// draw one continuous curve across it.
    ///
    /// Logging it is also evidence about the one before it — see
    /// `Array.pourCut(by:)`.
    func add(_ drink: Drink) {
        // A drink arriving after the occasion has ended starts the next one.
        closeSessionIfEnded()

        let target = sessionCovering(drink.consumedAt) ?? startSession(at: drink.consumedAt)
        if drink.consumedAt < target.startedAt {
            target.startedAt = drink.consumedAt
        }

        applyPourCut(of: drink, in: target)

        // A drink filled in from before this person's records start is
        // evidence that we were already keeping records then (5.7).
        person.backdateTracking(to: drink.consumedAt)

        let record = DrinkRecord(drink)
        record.session = target
        context.insert(record)
        target.invalidateSummary()

        reconcile(target)
        save()
        rebuild()
    }

    /// Shortens the drink this one interrupted, if it interrupted one.
    ///
    /// Only on `add`. Editing or deleting the interrupting drink afterwards
    /// does **not** give the earlier one its original duration back — that was
    /// a default, and the app has no record of a default it has replaced. The
    /// duration is editable on both rows, which is the way out.
    private func applyPourCut(of drink: Drink, in target: DrinkingSession) {
        guard let cut = target.sortedDrinks.pourCut(by: drink),
              let record = (target.drinks ?? []).first(where: { $0.id == cut.drinkID })
        else { return }

        record.drinkingMinutes = cut.drinkingMinutes
    }

    /// Corrects a drink. `target` defaults to the running session; the history
    /// detail passes a past one, because a mistake noticed three weeks later is
    /// still a mistake worth fixing.
    func update(_ drink: Drink, in target: DrinkingSession? = nil) {
        // Named `holder`, not `owner`: the store now has an `owner` person,
        // and a shadowed name in a method that writes to the database is the
        // kind of thing that reads fine and does the wrong thing.
        let holder = target ?? session
        guard let holder, let record = (holder.drinks ?? []).first(where: { $0.id == drink.id }) else { return }

        record.apply(drink)
        if let earliest = holder.sortedDrinks.first?.consumedAt {
            holder.startedAt = earliest
        }
        holder.invalidateSummary()
        // Changing a time moves the clearing point too, which can reopen a
        // session that had ended or close one that had not.
        reconcile(holder)
        save()
        rebuild()
    }

    func remove(_ drink: Drink, from target: DrinkingSession? = nil) {
        let holder = target ?? session
        guard let holder, let record = (holder.drinks ?? []).first(where: { $0.id == drink.id }) else { return }

        context.delete(record)
        holder.invalidateSummary()

        // An empty session is not history worth keeping.
        if holder.sortedDrinks.isEmpty {
            context.delete(holder)
            if holder === session { session = nil }
        }

        save()
        rebuild()
    }

    // A session is never ended by hand.
    //
    // There used to be an "End session" button. It answered a question nobody
    // asks: a session is over when the alcohol has cleared and a few hours have
    // passed (`SessionPolicy`), and that is a fact about the evening, not a
    // decision. Pressing it early would have written a closing time that is
    // simply wrong, and every drink after it would have opened a second session
    // on the same night. What the button looked like it was for — "I am done
    // drinking" — the app does not need to be told, because it is still
    // simulating the alcohol already in you either way.

    /// What would happen if the user had this drink.
    ///
    /// When correcting a logged drink, pass its id as `excluding` so the
    /// comparison is "the session without it" against "with the corrected
    /// version", rather than counting it twice.
    /// `in` selects which session the comparison is made against. A past
    /// session is evaluated with **its own** profile snapshot and limit, not
    /// today's — otherwise the projection would describe a night that never
    /// happened.
    ///
    /// The answer to the last question asked is kept, because a projection is
    /// six simulations and a SwiftUI body reads it several times per pass. See
    /// `ProjectionKey`.
    func project(
        _ candidate: Drink,
        excluding excludedID: UUID? = nil,
        in target: DrinkingSession? = nil
    ) -> BandedProjection {
        let holder = target ?? session
        let all = holder?.sortedDrinks ?? drinks
        // The same cut `add` will make, so the curve previewed above the Add
        // button is the curve you get after pressing it.
        let others = (excludedID.map { id in all.filter { $0.id != id } } ?? all)
            .shorteningPour(for: candidate)

        let key = ProjectionKey(
            profile: holder?.profile ?? person.profile,
            consumed: others,
            candidate: candidate,
            limit: holder?.limit ?? limit
        )
        if let lastProjection, lastProjection.key == key { return lastProjection.value }

        let result = engine.projectBand(
            profile: key.profile,
            consumed: key.consumed,
            candidate: key.candidate,
            limit: key.limit
        )
        lastProjection = (key, result)
        return result
    }

    /// Everything a projection depends on.
    ///
    /// Comparing eight drinks costs nothing against six RK4 runs, and it is the
    /// honest test: if all of it is equal, the answer cannot have changed.
    /// The consumed list already has the pour cut applied, so an edit that only
    /// shortens an earlier drink still registers here.
    private struct ProjectionKey: Equatable {
        let profile: BodyProfile
        let consumed: [Drink]
        let candidate: Drink
        let limit: Double
    }

    /// Not observed. A read of `project` happens *during* a body evaluation,
    /// and writing to an observed property there would invalidate the very view
    /// that asked.
    @ObservationIgnored
    private var lastProjection: (key: ProjectionKey, value: BandedProjection)?

    func tick() {
        now = .now
        closeSessionIfEnded()
    }

    // MARK: Plumbing

    private func rebuild() {
        let drinks = session?.sortedDrinks ?? []
        guard let session, !drinks.isEmpty else {
            band = .empty
            return
        }
        band = engine.simulateBand(profile: session.profile, drinks: drinks)
    }

    private func summary(for session: DrinkingSession, band: BACBand) -> SessionSummary {
        SessionSummary(
            peakRange: band.peakRange ?? 0...0,
            soberAt: band.soberRange()?.upperBound,
            totalUnits: session.totalUnits,
            drinkCount: session.drinks?.count ?? 0
        )
    }

    private func save() {
        do {
            try context.save()
        } catch {
            // Losing a drink silently is worse than a log line nobody reads.
            assertionFailure("Failed to save: \(error)")
        }
    }
}
