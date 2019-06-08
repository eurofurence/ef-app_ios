import EventBus

struct AcceptingEventFeedback: EventFeedback {
    
    private static let defaultStarRating = 3
    
    let eventBus: EventBus
    let eventIdentifier: EventIdentifier
    
    var feedback: String
    var starRating: Int
    
    init(eventBus: EventBus, eventIdentifier: EventIdentifier) {
        self.eventBus = eventBus
        self.eventIdentifier = eventIdentifier
        feedback = ""
        starRating = AcceptingEventFeedback.defaultStarRating
    }
    
    func submit(_ delegate: EventFeedbackDelegate) {
        let submitFeedbackEvent = DomainEvent.EventFeedbackReady(identifier: eventIdentifier, feedback: self, delegate: delegate)
        eventBus.post(submitFeedbackEvent)
    }
    
}
