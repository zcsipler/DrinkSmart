import Foundation
import BACKit

/// A monthly total reduced to what history needs — a value, so the aggregate
/// can be built and tested without a model context.
struct KnownMonth: Hashable, Sendable {
    let year: Int
    let month: Int
    let gramsEthanol: Double

    var totalUnits: Double { gramsEthanol / Physiology.gramsPerStandardUnit }

    /// The calendar month, in the given calendar.
    func interval(calendar: Calendar = .current) -> DateInterval? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let start = calendar.date(from: components) else { return nil }
        return calendar.dateInterval(of: .month, for: start)
    }
}
