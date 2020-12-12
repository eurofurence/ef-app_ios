import EventsWidgetLogic
import Foundation

struct DoNotFilterAnyEventsPolicy: TimelineEntryFilteringPolicy {
    
    func filterEvents(_ events: [Event], inGroupStartingAt startTime: Date) -> [Event] {
        events
    }
    
}
