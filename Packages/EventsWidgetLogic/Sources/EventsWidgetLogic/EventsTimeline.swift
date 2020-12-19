public struct EventsTimeline: Equatable {
    
    public var snapshot: EventTimelineEntry
    public var entries: [EventTimelineEntry]
    
    public init(snapshot: EventTimelineEntry, entries: [EventTimelineEntry]) {
        self.snapshot = snapshot
        self.entries = entries
    }
    
}
