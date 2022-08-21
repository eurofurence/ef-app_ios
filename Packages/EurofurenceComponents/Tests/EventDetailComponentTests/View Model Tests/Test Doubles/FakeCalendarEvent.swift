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
    private(set) var lastActionSender: Any?
    func addToCalendar(_ sender: Any?) {
        lastAction = .added
        lastActionSender = sender
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
