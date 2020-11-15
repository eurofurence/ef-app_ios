import WidgetKit

struct EventsTimelineEntry: TimelineEntry {
    
    let date: Date
    let filter: EventFilter
    let events: EventsCollection
    
}
