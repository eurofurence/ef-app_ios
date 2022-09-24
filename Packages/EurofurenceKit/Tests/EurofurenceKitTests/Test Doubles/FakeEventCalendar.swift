import EurofurenceKit

class FakeEventCalendar: EventCalendar {
    
    private var entries = [EventCalendarEntry]()
    func simulateContainsEvent(_ entry: EventCalendarEntry) {
        entries.append(entry)
    }
    
    func contains(entry: EventCalendarEntry) -> Bool {
        entries.contains(entry)
    }
    
}
