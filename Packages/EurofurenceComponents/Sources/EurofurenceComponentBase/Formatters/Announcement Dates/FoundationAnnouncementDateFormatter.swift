import Foundation

public struct FoundationAnnouncementDateFormatter: AnnouncementDateFormatter {

    private let formatter: DateFormatter
    public static let shared = FoundationAnnouncementDateFormatter()

    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }

    public func string(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
