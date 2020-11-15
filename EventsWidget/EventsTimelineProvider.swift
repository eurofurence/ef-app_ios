import EventsWidgetLogic
import WidgetKit

struct EventsTimelineProvider: IntentTimelineProvider {
    
    private let sampleEvents: [EventViewModel] = [
        EventViewModel(
            id: UUID().uuidString,
            title: "Trans Meet-Up",
            location: "Nizza",
            formattedStartTime: "13:00",
            formattedEndTime: "14:30"
        ),
        
        EventViewModel(
            id: UUID().uuidString,
            title: "Dealer's Den",
            location: "Dealer's Den - Convention Center Foyer 3",
            formattedStartTime: "13:30",
            formattedEndTime: "15:00"
        ),
        
        EventViewModel(
            id: UUID().uuidString,
            title: "Funny Animals and Amerimanga in Sonic the Hedgehog Archie Series",
            location: "Nizza",
            formattedStartTime: "17:30",
            formattedEndTime: "18:30"
        )
    ]
    
    func placeholder(in context: Context) -> EventTimelineEntry {
        EventTimelineEntry(
            date: Date(),
            events: sampleEvents,
            additionalEventsCount: 1
        )
    }

    func getSnapshot(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (EventTimelineEntry) -> ()
    ) {
        let entry = EventTimelineEntry(
            date: Date(),
            events: [],
            additionalEventsCount: 0
        )
        
        completion(entry)
    }

    func getTimeline(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (Timeline<EventTimelineEntry>) -> ()
    ) {
        let repository = WidgetRepositoryAdapter(intent: configuration)
        let controller = EventsTimelineController(
            repository: repository,
            options: EventsTimelineController.Options(
                maximumEventsPerEntry: 3,
                timelineStartDate: Date()
            )
        )
        
        controller.makeEntries { (entries) in
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
}
