import EventBus

struct AcceptingEventFeedback: EventFeedback {
    
    let eventBus: EventBus
    let eventIdentifier: EventIdentifier
    
    var feedback: String
    var rating: Int
    
    func submit(_ delegate: EventFeedbackDelegate) {
        let submitFeedbackEvent = DomainEvent.EventFeedbackReady(identifier: eventIdentifier, feedback: self, delegate: delegate)
        eventBus.post(submitFeedbackEvent)
    }
    
}
