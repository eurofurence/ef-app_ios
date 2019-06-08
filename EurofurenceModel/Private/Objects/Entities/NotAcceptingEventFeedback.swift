class NotAcceptingEventFeedback: EventFeedback {
    
    var feedback: String
    var starRating: Int
    
    init() {
        feedback = "Not Accepting Feedback"
        starRating = -1
    }
    
    func submit(_ delegate: EventFeedbackDelegate) {
        delegate.eventFeedbackSubmissionDidFail(self)
    }
    
}
