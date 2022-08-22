import EurofurenceModel

public protocol CalendarEventRepository {
    
    func calendarEvent(for identifier: EventIdentifier) -> CalendarEvent?
    
}
