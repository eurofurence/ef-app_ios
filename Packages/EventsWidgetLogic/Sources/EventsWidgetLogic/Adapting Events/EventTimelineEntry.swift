public struct EventTimelineEntry: Equatable {
    
    public var events: [EventViewModel]
    public var additionalEventsCount: Int
    
    public init(events: [EventViewModel], additionalEventsCount: Int) {
        self.events = events
        self.additionalEventsCount = additionalEventsCount
    }
    
}
