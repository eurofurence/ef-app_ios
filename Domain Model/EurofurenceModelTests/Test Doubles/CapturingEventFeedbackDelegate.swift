import EurofurenceModel

class CapturingEventFeedbackDelegate: EventFeedbackDelegate {
    
    enum State {
        case unset
        case failed
        case success
    }
    
    private(set) var feedbackState: State = .unset
    
    func eventFeedbackSubmissionDidFinish(_ feedback: EventFeedback) {
        feedbackState = .success
    }
    
    func eventFeedbackSubmissionDidFail(_ feedback: EventFeedback) {
        feedbackState = .failed
    }
    
}
