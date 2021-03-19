import Foundation

public struct FoundationDateRangeFormatter: DateRangeFormatter {

    public static let shared = FoundationDateRangeFormatter()
    private let formatter = EurofurenceDateIntervalFormatter()

    private init() {
        formatter.dateTemplate = "E, d MMM HH:mm"
    }

    public func string(from startDate: Date, to endDate: Date) -> String {
        return formatter.string(from: startDate, to: endDate)
    }

}
