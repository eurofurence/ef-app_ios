import EurofurenceIntentDefinitions
import EurofurenceModel

struct DonateIntentEventInteractionRecorder: EventInteractionRecorder {
    
    var eventsService: EventsService
    var eventIntentDonor: EventIntentDonor
    
    func makeInteractionRecorder(for event: EventIdentifier) {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return }
        
        let intentDefinition = ViewEventIntentDefinition(identifier: event, eventName: entity.title)
        eventIntentDonor.donateEventIntent(definition: intentDefinition)
    }
    
}
