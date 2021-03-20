import Foundation

public struct FoundationShortFormDateFormatter: ShortFormDateFormatter {

    public static let shared = FoundationShortFormDateFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateFormat = "E d"
    }

    public func dateString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
