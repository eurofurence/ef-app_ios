import EurofurenceModel

struct IntentBasedEventInteractionRecorder: EventInteractionRecorder {
    
    var eventsService: EventsService
    var eventIntentDonor: EventIntentDonor
    
    func recordInteraction(for event: EventIdentifier) {
        guard let entity = eventsService.fetchEvent(identifier: event) else { return }
        
        let intentTraits = EventIntentTraits(identifier: event,
                                             title: entity.title,
                                             subtitle: entity.room.name,
                                             startTime: entity.startDate,
                                             endTime: entity.endDate)
        eventIntentDonor.donateEventIntent(traits: intentTraits)
    }
    
}
