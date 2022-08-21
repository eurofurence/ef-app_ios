import EurofurenceModel

public class AddEventToCalendarAction: EventActionViewModel, CalendarEventDelegate {
    
    private let calendarEvent: CalendarEvent
    private var visitor: EventActionViewModelVisitor?
    
    init(calendarEvent: CalendarEvent) {
        self.calendarEvent = calendarEvent
        calendarEvent.delegate = self
    }
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        self.visitor = visitor
        visitor.visitActionTitle("Remove from Calendar")
    }
    
    public func perform(sender: Any?) {
        calendarEvent.removeFromCalendar()
    }
    
    public func calendarEvent(_ calendarEvent: CalendarEvent, presenceDidChange eventPresence: CalendarEventPresence) {
        visitor?.visitActionTitle("Add to Calendar")
    }
    
}
