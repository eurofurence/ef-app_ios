import Foundation

public struct EventTimelineEntry: Equatable {
    
    public var date: Date
    public var eventCategory: EventCategory
    public var events: [EventViewModel]
    public var additionalEventsCount: Int
    
    public init(
        date: Date,
        eventCategory: EventCategory,
        events: [EventViewModel],
        additionalEventsCount: Int
    ) {
        self.date = date
        self.eventCategory = eventCategory
        self.events = events
        self.additionalEventsCount = additionalEventsCount
    }
    
}
