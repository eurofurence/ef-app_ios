extension DomainEvent {
    
    struct EventFeedbackReady {
        var identifier: EventIdentifier
        var feedback: EventFeedback
        var delegate: EventFeedbackDelegate
        
        var rating: Int {
            return feedback.rating
        }
        
        var eventFeedback: String {
            return feedback.feedback
        }
    }
    
}
