import Foundation

public struct EventTimelineEntry: Equatable {
    
    public var date: Date
    public var events: [EventViewModel]
    public var additionalEventsCount: Int
    
    public init(date: Date, events: [EventViewModel], additionalEventsCount: Int) {
        self.date = date
        self.events = events
        self.additionalEventsCount = additionalEventsCount
    }
    
}
