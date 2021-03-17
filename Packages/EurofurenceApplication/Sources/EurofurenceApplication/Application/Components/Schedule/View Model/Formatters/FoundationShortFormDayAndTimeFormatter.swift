import ComponentBase
import Foundation

struct FoundationShortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter {

    static let shared = FoundationShortFormDayAndTimeFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    }

    func dayAndHoursString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
