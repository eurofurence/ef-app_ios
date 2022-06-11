import EventsWidgetLogic
import Foundation

struct AccessibleEventTimeFormatter: EventTimeFormatter {
    
    static let shared = AccessibleEventTimeFormatter()
    private let formatter: DateComponentsFormatter
    
    private init() {
        formatter = DateComponentsFormatter()
        formatter.unitsStyle = .spellOut
    }
    
    func string(from date: Date) -> String {
        let components: Set<Calendar.Component> = [.hour, .minute]
        let dateComponents = Calendar.current.dateComponents(components, from: date)
        
        return formatter.string(from: dateComponents) ?? ""
    }
    
}
