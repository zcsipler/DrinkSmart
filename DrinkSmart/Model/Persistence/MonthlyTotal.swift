import Foundation
import SwiftData
import BACKit

/// A month known only as a total.
///
/// ## Why a third kind of knowledge
///
/// History distinguishes "did not drink" from "do not know" (5.7): a day after
/// `trackingStartedAt` with nothing logged is dry, a day before it is unknown.
/// That covers two of the three ways someone can know their own past. The
/// third is a person who kept a tally before the app — a spreadsheet of grams
/// per month, say — and can bring the totals but not the evenings.
///
/// Moving `trackingStartedAt` back to cover those months would be wrong: every
/// day in them would read as dry, and the count of sober days would be
/// invented. Leaving the months out is wrong too: a year view that shows
/// nothing for a year the person drank through is not "no data", it is a
/// lie of omission. So the month total is its own record, and the aggregate
/// treats it as exactly what it is — the sum is known, the days are not.
///
/// ## Rules
///
/// - A monthly total never produces a dry day or a drinking day. Day states
///   inside such a month stay `.unknown`; only the period knows its sum.
/// - **Except zero.** A month recorded as 0 g is evidence that every day of it
///   was dry, and the aggregate marks them so. This is the one place monthly
///   knowledge becomes daily knowledge, and it is the one place the inference
///   is sound.
/// - Sessions win. A month that has any recorded session ignores its total:
///   the sessions are the finer record, and adding the two would count the
///   same drinks twice.
///
/// ## Storage
///
/// Grams of ethanol, not units or drinks: it is the one quantity every source
/// can be converted to, and `Physiology.gramsPerStandardUnit` turns it into
/// what the screens show. Keyed by person, year and month rather than by an
/// interval, because a month is a calendar concept and the import matches on
/// it. Every property has a default, for CloudKit, like the other models.
@Model
final class MonthlyTotal {
    var id: UUID = UUID()
    var personID: UUID = UUID()
    var year: Int = 2000
    var month: Int = 1
    var gramsEthanol: Double = 0

    init(id: UUID = UUID(), personID: UUID, year: Int, month: Int, gramsEthanol: Double) {
        self.id = id
        self.personID = personID
        self.year = year
        self.month = month
        self.gramsEthanol = gramsEthanol
    }

    var totalUnits: Double { gramsEthanol / Physiology.gramsPerStandardUnit }

    /// The value type the aggregate works with.
    var asKnownMonth: KnownMonth {
        KnownMonth(year: year, month: month, gramsEthanol: gramsEthanol)
    }
}
