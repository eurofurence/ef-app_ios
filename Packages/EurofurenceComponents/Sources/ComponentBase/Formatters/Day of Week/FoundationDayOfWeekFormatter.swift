import Foundation

public struct FoundationDayOfWeekFormatter: DayOfWeekFormatter {
    
    public static let shared = FoundationDayOfWeekFormatter()
    private let formatter: DateFormatter
    
    private init() {
        formatter = EurofurenceDateFormatter()
        formatter.dateFormat = "EEEE"
    }
    
    public func formatDayOfWeek(from date: Date) -> String {
        return formatter.string(from: date)
    }
    
}
