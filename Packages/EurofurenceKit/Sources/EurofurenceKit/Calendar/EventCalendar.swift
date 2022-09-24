import Combine

public typealias EventCalendarChangedPublisher = PassthroughSubject<EventCalendar, Never>

public protocol EventCalendar {
    
    var calendarChanged: EventCalendarChangedPublisher { get }
    
    func contains(entry: EventCalendarEntry) -> Bool
    
}
