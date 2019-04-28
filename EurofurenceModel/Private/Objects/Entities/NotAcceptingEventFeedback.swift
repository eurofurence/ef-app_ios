struct NotAcceptingEventFeedback: EventFeedback {
    
    var feedback: String
    var rating: Int
    
    init() {
        feedback = "Not Accepting Feedback"
        rating = -1
    }
    
    func submit(_ delegate: EventFeedbackDelegate) {
        delegate.eventFeedbackSubmissionDidFail(self)
    }
    
}
