import Foundation

public struct FoundationShortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter {

    public static let shared = FoundationShortFormDayAndTimeFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }

    public func dayAndHoursString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
