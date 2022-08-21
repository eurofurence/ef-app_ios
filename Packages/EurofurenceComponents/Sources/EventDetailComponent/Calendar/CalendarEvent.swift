public protocol CalendarEvent: AnyObject {
    
    /* weak */ var delegate: CalendarEventDelegate? { get set }
    
    func addToCalendar()
    func removeFromCalendar()
    
}

public protocol CalendarEventDelegate: AnyObject {
    
    func calendarEvent(_ calendarEvent: CalendarEvent, presenceDidChange eventPresence: CalendarEventPresence)
    
}
