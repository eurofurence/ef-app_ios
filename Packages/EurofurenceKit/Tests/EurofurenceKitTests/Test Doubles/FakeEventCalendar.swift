import EurofurenceKit

class FakeEventCalendar: EventCalendar {
    
    private var entries = [EventCalendarEntry]()
    func simulateContainsEvent(_ entry: EventCalendarEntry) {
        entries.append(entry)
        calendarChanged.send(self)
    }
    
    let calendarChanged = EventCalendarChangedPublisher()
    
    func contains(entry: EventCalendarEntry) -> Bool {
        entries.contains(entry)
    }
    
}
