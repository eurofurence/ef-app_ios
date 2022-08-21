import EurofurenceModel

public class AddEventToCalendarAction: EventActionViewModel, CalendarEventDelegate {
    
    private let calendarEvent: CalendarEvent
    private var eventPresence: CalendarEventPresence?
    private var visitor: EventActionViewModelVisitor?
    
    init(calendarEvent: CalendarEvent) {
        self.calendarEvent = calendarEvent
        calendarEvent.delegate = self
    }
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        self.visitor = visitor
        updateVisibleActionTitle()
    }
    
    public func perform(sender: Any?) {
        guard let eventPresence = eventPresence else { return }
        
        switch eventPresence {
        case .present:
            calendarEvent.removeFromCalendar()
            
        case .absent:
            calendarEvent.addToCalendar(sender)
        }
    }
    
    public func calendarEvent(_ calendarEvent: CalendarEvent, presenceDidChange eventPresence: CalendarEventPresence) {
        self.eventPresence = eventPresence
        updateVisibleActionTitle()
    }
    
    private func updateVisibleActionTitle() {
        guard let eventPresence = eventPresence else { return }
        
        switch eventPresence {
        case .present:
            visitor?.visitActionTitle("Remove from Calendar")
            
        case .absent:
            visitor?.visitActionTitle("Add to Calendar")
        }
    }
    
}
