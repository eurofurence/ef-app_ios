import EurofurenceModel
import EurofurenceIntentDefinitions

struct IntentBasedEventInteractionRecorder: EventInteractionRecorder {
    
    var eventsService: EventsService
    var eventIntentDonor: EventIntentDonor
    
    func recordInteraction(for event: EventIdentifier) {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return }
        
        let intentTraits = EventIntentTraits(identifier: event, eventName: entity.title)
        eventIntentDonor.donateEventIntent(traits: intentTraits)
    }
    
}
