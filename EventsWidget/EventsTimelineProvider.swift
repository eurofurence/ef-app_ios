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
        fetchEventsTimeline(configuration: configuration, context: context) { (eventsTimeline) in
            completion(eventsTimeline.snapshot)
        }
    }

    func getTimeline(
        for configuration: ViewEventsIntent,
        in context: Context,
        completion: @escaping (Timeline<EventTimelineEntry>) -> ()
    ) {
        fetchEventsTimeline(configuration: configuration, context: context) { (eventsTimeline) in
            let timeline = Timeline(entries: eventsTimeline.entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    private func fetchEventsTimeline(
        configuration: ViewEventsIntent,
        context: Context,
        completionHandler: @escaping (EventsTimeline) -> Void
    ) {
        let repository = WidgetRepositoryAdapter(intent: configuration)
        let controller = EventsTimelineController(
            repository: repository,
            eventTimeFormatter: HoursAndMinutesEventTimeFormatter.shared
        )
        
        let components = DateComponents(calendar: .current, timeZone: .current, year: 2019, month: 8, day: 15, hour: 14)
        let date = Calendar.current.date(from: components)!
        
        let widgetContext = EventWidgetContext(timelineContext: context)
        let options = EventsTimelineController.TimelineOptions(
            maximumEventsPerEntry: widgetContext.recommendedNumberOfEvents,
            timelineStartDate: date
        )
        
        controller.makeTimeline(options: options, completionHandler: completionHandler)
    }
    
}
