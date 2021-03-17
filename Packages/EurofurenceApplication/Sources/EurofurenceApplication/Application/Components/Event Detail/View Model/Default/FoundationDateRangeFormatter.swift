import ComponentBase
import Foundation

struct FoundationDateRangeFormatter: DateRangeFormatter {

    static let shared = FoundationDateRangeFormatter()
    private let formatter = EurofurenceDateIntervalFormatter()

    private init() {
        formatter.dateTemplate = "E, d MMM HH:mm"
    }

    func string(from startDate: Date, to endDate: Date) -> String {
        return formatter.string(from: startDate, to: endDate)
    }

}
