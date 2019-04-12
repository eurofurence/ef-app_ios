import Foundation

struct FoundationAnnouncementDateFormatter: AnnouncementDateFormatter {

    private let formatter: DateFormatter
    static let shared = FoundationAnnouncementDateFormatter()

    private init() {
        formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }

    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
