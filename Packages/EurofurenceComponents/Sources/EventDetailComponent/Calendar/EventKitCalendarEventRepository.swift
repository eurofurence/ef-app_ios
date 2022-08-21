import EventKit

public class EventKitCalendarEventRepository: CalendarEventRepository {
    
    public init() {
        
    }
    
    public func calendarEvent(for identifier: String) -> CalendarEvent {
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
