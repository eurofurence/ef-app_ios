import EurofurenceIntentDefinitions
import EurofurenceModel

struct DonateIntentEventInteractionRecorder: EventInteractionRecorder {
    
    var eventsService: EventsService
    var eventIntentDonor: EventIntentDonor
    
    func makeInteraction(for event: EventIdentifier) -> Interaction? {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return nil }
        
        let intentDefinition = ViewEventIntentDefinition(identifier: event, eventName: entity.title)
        eventIntentDonor.donateEventIntent(definition: intentDefinition)
        
        return nil
    }
    
}
