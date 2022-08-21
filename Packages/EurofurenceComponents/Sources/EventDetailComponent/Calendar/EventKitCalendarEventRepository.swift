import EurofurenceModel
import EventKit

public class EventKitCalendarEventRepository: CalendarEventRepository {
    
    public init() {
        
    }
    
    public func calendarEvent(for identifier: EventIdentifier) -> CalendarEvent {
        EventKitCalendarEvent()
    }
    
    private class EventKitCalendarEvent: CalendarEvent {
        
        var delegate: CalendarEventDelegate?
        
        func addToCalendar() {
            
        }
        
        func removeFromCalendar() {
            
        }
        
    }
    
}
