import Foundation

struct FoundationHoursDateFormatter: HoursDateFormatter {

    static let shared = FoundationHoursDateFormatter()
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
    }

    func hoursString(from date: Date) -> String {
        return formatter.string(from: date)
    }

}
