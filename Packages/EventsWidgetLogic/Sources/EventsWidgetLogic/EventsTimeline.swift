import Foundation.NSDate

public struct EventsTimeline: Equatable {
    
    public var entries: [EventTimelineEntry]
    
    public var snapshot: EventTimelineEntry {
        entries.first ?? EventTimelineEntry(date: Date(), events: [], additionalEventsCount: 0)
    }
    
    public init(entries: [EventTimelineEntry]) {
        self.entries = entries
    }
    
}
