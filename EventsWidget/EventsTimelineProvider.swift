import EurofurenceApplicationSession
import EurofurenceModel
import EurofurenceIntentDefinitions
import EventsWidgetLogic
import WidgetKit

struct EventsTimelineProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> EventTimelineEntry {
        let widgetContext = EventWidgetContext(timelineContext: context)
        
        let sampleEvents = [
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
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "Fursuit Photoshoot Registration",
                location: "Fursuit Photoshoot Registration - Estrel Hall B",
                formattedStartTime: "19:00",
                formattedEndTime: "20:30"
            ),
            
            EventViewModel(
                id: UUID().uuidString,
                title: "International Snack Exchange",
                location: "ECC Room 3",
                formattedStartTime: "22:00",
                formattedEndTime: "00:30"
            )
        ]
        
        let placeholderEvents = sampleEvents.prefix(widgetContext.recommendedNumberOfEvents)
        
        return EventTimelineEntry(
            date: Date(),
            content: .events(viewModels: Array(placeholderEvents), additionalEventsCount: 1),
            context: EventTimelineEntry.Context(category: .upcoming, isFavouritesOnly: false)
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
        let clock = ControllableClock()
        let session = EurofurenceSessionBuilder.buildingForEurofurenceApplication().with(clock).build()
        let eventsService = session.services.events
        let bridge = EventsBridge()
        eventsService.add(bridge)
        
        let specification = IntentBasedWidgetSpecificationFactory.makeSpecification(
            intent: configuration,
            clock: clock
        )
        
        let filteringPolicy = SpecificationUseCaseTimelineFilteringPolicy(
            bridge: bridge,
            clock: clock,
            specification: specification
        )
        
        let controller = EventsTimelineController(
            repository: bridge,
            filteringPolicy: filteringPolicy,
            eventTimeFormatter: HoursAndMinutesEventTimeFormatter.shared
        )
        
        let components = DateComponents(calendar: .current, timeZone: .current, year: 2019, month: 8, day: 15, hour: 11)
        let date = Calendar.current.date(from: components)!
        
        let widgetContext = EventWidgetContext(timelineContext: context)
        let options = EventsTimelineController.TimelineOptions(
            maximumEventsPerEntry: widgetContext.recommendedNumberOfEvents,
            timelineStartDate: date,
            eventCategory: EventCategory(filter: configuration.filter),
            isFavouritesOnly: configuration.favouritesOnly?.boolValue ?? false
        )
        
        controller.makeTimeline(options: options, completionHandler: completionHandler)
    }
    
}
