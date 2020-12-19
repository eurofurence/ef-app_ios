import EventsWidgetLogic
import Foundation.NSDate

class FakeEventTimeFormatter: EventTimeFormatter {
    
    private var stubbedStrings = [Date: String]()
    
    func string(from date: Date) -> String {
        if let existing = stubbedStrings[date] {
            return existing
        } else {
            let newString = UUID().uuidString
            stubbedStrings[date] = newString
            
            return newString
        }
    }
    
}
