import ComponentBase
import Foundation

struct FoundationDayOfWeekFormatter: DayOfWeekFormatter {
    
    static let shared = FoundationDayOfWeekFormatter()
    private let formatter: DateFormatter
    
    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateFormat = "EEEE"
    }
    
    func formatDayOfWeek(from date: Date) -> String {
        return formatter.string(from: date)
    }
    
}
