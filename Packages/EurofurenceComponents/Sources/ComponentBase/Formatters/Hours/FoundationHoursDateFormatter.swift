import Foundation

public struct FoundationHoursDateFormatter: HoursDateFormatter {

    public static let shared = FoundationHoursDateFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateFormat = "HH:mm"
    }

    public func hoursString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
