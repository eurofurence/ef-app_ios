import EurofurenceIntentDefinitions
import EurofurenceModel

public struct SystemEventInteractionsRecorder: EventInteractionRecorder {
    
    private let eventsService: EventsService
    private let eventIntentDonor: EventIntentDonor
    private let activityFactory: ActivityFactory
    
    public init(
        eventsService: EventsService,
        eventIntentDonor: EventIntentDonor,
        activityFactory: ActivityFactory
    ) {
        self.eventsService = eventsService
        self.eventIntentDonor = eventIntentDonor
        self.activityFactory = activityFactory
    }
    
    public func makeInteraction(for event: EventIdentifier) -> Interaction? {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return nil }
        
        let intentDefinition = ViewEventIntentDefinition(identifier: event, eventName: entity.title)
        eventIntentDonor.donateEventIntent(definition: intentDefinition)
        
        let activityTitle = String.viewEvent(named: entity.title)
        let url = entity.contentURL
        let activity = activityFactory.makeActivity(
            type: "org.eurofurence.activity.view-event",
            title: activityTitle,
            url: url
        )
        
        activity.markEligibleForPublicIndexing()
        
        return ActivityInteraction(activity: activity)
    }
    
}
