import EventBus

struct AcceptingEventFeedback: EventFeedback {
    
    private static let defaultEventRating = 3
    
    let eventBus: EventBus
    let eventIdentifier: EventIdentifier
    
    var feedback: String
    var rating: Int
    
    init(eventBus: EventBus, eventIdentifier: EventIdentifier) {
        self.eventBus = eventBus
        self.eventIdentifier = eventIdentifier
        feedback = ""
        rating = AcceptingEventFeedback.defaultEventRating
    }
    
    func submit(_ delegate: EventFeedbackDelegate) {
        let submitFeedbackEvent = DomainEvent.EventFeedbackReady(identifier: eventIdentifier, feedback: self, delegate: delegate)
        eventBus.post(submitFeedbackEvent)
    }
    
}
