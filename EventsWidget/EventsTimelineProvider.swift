import WidgetKit

struct EventsTimelineProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> EventsTimelineEntry {
        EventsTimelineEntry(date: Date(), filter: .upcoming, events: [])
    }

    func getSnapshot(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (EventsTimelineEntry) -> ()
    ) {
        let entry = EventsTimelineEntry(date: Date(), filter: .upcoming, events: [])
        completion(entry)
    }

    func getTimeline(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (Timeline<EventsTimelineEntry>) -> ()
    ) {
        let events: [EventViewModel] = [
            EventViewModel(
                formattedStartTime: "13:00",
                formattedEndTime: "14:30",
                eventTitle: "Trans Meet-Up",
                eventLocation: "Nizza"
            ),
            
            EventViewModel(
                formattedStartTime: "13:30",
                formattedEndTime: "15:00",
                eventTitle: "Dealer's Den",
                eventLocation: "Dealer's Den - Convention Center Foyer 3"
            ),
            
            EventViewModel(
                formattedStartTime: "17:30",
                formattedEndTime: "18:30",
                eventTitle: "Funny Animals and Amerimanga in Sonic the Hedgehog Archie Series",
                eventLocation: "Nizza"
            )
        ]
        
        let entry = EventsTimelineEntry(
            date: Date(),
            filter: .upcoming,
            events: events
        )

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}
