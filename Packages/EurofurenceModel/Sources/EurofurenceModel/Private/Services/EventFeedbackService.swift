struct EventFeedbackService {
    
    private let api: API
    private let subscription: Any
    
    init(api: API, eventBus: EventBus) {
        self.api = api
        
        subscription = eventBus.subscribe(consumer: SubmitEventFeedback(api: api))
    }
    
    private struct SubmitEventFeedback: EventConsumer {
        
        let api: API
        
        func consume(event: DomainEvent.EventFeedbackReady) {
            let request = EventFeedbackRequest(
                id: event.identifier.rawValue,
                rating: event.rating,
                feedback: event.eventFeedback
            )
            
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
    
}
