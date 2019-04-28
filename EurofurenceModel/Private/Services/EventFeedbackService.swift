import EventBus

class EventFeedbackService: EventConsumer {
    
    private let api: API
    
    public init(api: API) {
        self.api = api
    }
    
    func consume(event: DomainEvent.EventFeedbackReady) {
        let request = EventFeedbackRequest(id: event.identifier.rawValue, rating: event.rating, feedback: event.eventFeedback)
        let delegate = event.delegate
        api.submitEventFeedback(request) { (success) in
            if success {
                delegate.eventFeedbackSubmissionDidFinish(event.feedback)
            } else {
                delegate.eventFeedbackSubmissionDidFail(event.feedback)
            }
        }
    }
    
}
