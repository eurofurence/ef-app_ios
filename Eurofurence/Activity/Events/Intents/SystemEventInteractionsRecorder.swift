import EurofurenceIntentDefinitions
import EurofurenceModel

struct SystemEventInteractionsRecorder: EventInteractionRecorder {
    
    var eventsService: EventsService
    var eventIntentDonor: EventIntentDonor
    var activityFactory: ActivityFactory
    
    func makeInteraction(for event: EventIdentifier) -> Interaction? {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return nil }
        
        let intentDefinition = ViewEventIntentDefinition(identifier: event, eventName: entity.title)
        eventIntentDonor.donateEventIntent(definition: intentDefinition)
        
        let activityTitle = String.viewEvent(named: entity.title)
        let activity = activityFactory.makeActivity(type: "org.eurofurence.activity.view-event", title: activityTitle)
        
        return ActivityInteraction(activity: activity)
    }
    
}
