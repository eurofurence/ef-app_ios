import Combine

public typealias EventCalendarChangedPublisher = PassthroughSubject<EventCalendar, Never>

public protocol EventCalendar {
    
    var calendarChanged: EventCalendarChangedPublisher { get }
    
    func add(entry: EventCalendarEntry) throws
    func remove(entry: EventCalendarEntry)
    func contains(entry: EventCalendarEntry) -> Bool
    
}
