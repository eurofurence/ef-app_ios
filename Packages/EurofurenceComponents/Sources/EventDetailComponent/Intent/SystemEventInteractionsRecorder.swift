import ComponentBase
import EurofurenceModel
import func Foundation.NSLocalizedString

public struct SystemEventInteractionsRecorder: EventInteractionRecorder {
    
    private let eventsService: ScheduleRepository
    private let eventIntentDonor: EventIntentDonor
    private let activityFactory: ActivityFactory
    
    public init(
        eventsService: ScheduleRepository,
        eventIntentDonor: EventIntentDonor,
        activityFactory: ActivityFactory
    ) {
        self.eventsService = eventsService
        self.eventIntentDonor = eventIntentDonor
        self.activityFactory = activityFactory
    }
    
    public func makeInteraction(for event: EventIdentifier) -> Interaction? {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return nil }
        
        let format = NSLocalizedString(
            "ViewEventFormatString",
            bundle: .module,
            comment: "Format string used for handoff titles for events"
        )
        
        let activityTitle = String.localizedStringWithFormat(format, entity.title)
        let url = entity.contentURL
        let activity = activityFactory.makeActivity(
            type: "org.eurofurence.activity.view-event",
            title: activityTitle,
            url: url
        )
        
        activity.markEligibleForPublicIndexing()
        
        let intentDefinition = ViewEventIntentDefinition(identifier: event, eventName: entity.title)
        let donation = EventDonation(intentDefinition: intentDefinition, donor: eventIntentDonor)
        
        return ActivityInteraction(activity: activity, donation: donation)
    }
    
    private struct EventDonation: ActivityDonation {
        
        var intentDefinition: ViewEventIntentDefinition
        var donor: EventIntentDonor?
        
        func donate() {
            donor?.donateEventIntent(definition: intentDefinition)
        }
        
    }
    
}
