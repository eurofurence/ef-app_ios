import EurofurenceKit

class FakeEventCalendar: EventCalendar {
    
    let calendarChanged = EventCalendarChangedPublisher()
    
    private var entries = [EventCalendarEntry]() {
        didSet {
            calendarChanged.send(self)
        }
    }
    
    func contains(entry: EventCalendarEntry) -> Bool {
        entries.contains(entry)
    }
    
    func add(entry: EventCalendarEntry) {
        entries.append(entry)
    }
    
    func remove(entry: EventCalendarEntry) {
        if let idx = entries.firstIndex(of: entry) {
            entries.remove(at: idx)
        }
    }
    
    func numberOfInstances(of entry: EventCalendarEntry) -> Int {
        entries.filter({ $0 == entry }).count
    }
    
}
