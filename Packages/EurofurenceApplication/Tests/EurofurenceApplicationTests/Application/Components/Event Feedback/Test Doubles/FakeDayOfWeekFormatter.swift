import EurofurenceApplication
import Foundation

class FakeDayOfWeekFormatter: DayOfWeekFormatter {
    
    private var stubbedData = [Date: String]()
    
    func stub(_ formattedDayOfWeek: String, for date: Date) {
        stubbedData[date] = formattedDayOfWeek
    }
    
    func formatDayOfWeek(from date: Date) -> String {
        return stubbedData[date] ?? ""
    }
    
}
