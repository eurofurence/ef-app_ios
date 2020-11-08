import WidgetKit

struct EventsTimelineEntry: TimelineEntry {
    
    let date: Date
    let filter: Filter
    let events: EventsCollection
    
}
