import ComponentBase
import Foundation

public class FakeDayOfWeekFormatter: DayOfWeekFormatter {
    
    private var stubbedData = [Date: String]()
    
    public init() {
        
    }
    
    public func stub(_ formattedDayOfWeek: String, for date: Date) {
        stubbedData[date] = formattedDayOfWeek
    }
    
    public func formatDayOfWeek(from date: Date) -> String {
        return stubbedData[date] ?? ""
    }
    
}
