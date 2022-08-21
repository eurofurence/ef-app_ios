import EurofurenceModel
import EventDetailComponent

class FakeCalendarEvent: CalendarEvent {
    
    enum CalendarAction: Equatable {
        case unset
        case added
        case removed
    }
    
    weak var delegate: CalendarEventDelegate?
    
    private(set) var lastAction: CalendarAction = .unset
    func addToCalendar() {
        lastAction = .added
        delegate?.calendarEvent(self, presenceDidChange: .present)
    }
    
    func removeFromCalendar() {
        lastAction = .removed
        delegate?.calendarEvent(self, presenceDidChange: .absent)
    }
    
    func simulateEventPresent() {
        delegate?.calendarEvent(self, presenceDidChange: .present)
    }
    
    func simulateEventAbsent() {
        delegate?.calendarEvent(self, presenceDidChange: .absent)
    }
    
}
