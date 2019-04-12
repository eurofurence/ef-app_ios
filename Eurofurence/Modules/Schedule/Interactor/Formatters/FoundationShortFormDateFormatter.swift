import Foundation

struct FoundationShortFormDateFormatter: ShortFormDateFormatter {

    static let shared = FoundationShortFormDateFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "E d"
    }

    func dateString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
