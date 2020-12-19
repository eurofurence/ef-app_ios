import EventsWidgetLogic
import Foundation

struct HoursAndMinutesEventTimeFormatter: EventTimeFormatter {
    
    static let shared = HoursAndMinutesEventTimeFormatter()
    private let formatter: DateFormatter
    
    private init() {
        formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
    }
    
    func string(from date: Date) -> String {
        formatter.string(from: date)
    }
       
}
