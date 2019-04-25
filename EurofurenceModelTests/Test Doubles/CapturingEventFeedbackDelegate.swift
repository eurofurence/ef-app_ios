import EurofurenceModel

class CapturingEventFeedbackDelegate: EventFeedbackDelegate {
    
    enum State {
        case unset
        case failed
    }
    
    private(set) var feedbackState: State = .unset
    
    func eventFeedbackSubmissionDidFinish(_ feedback: EventFeedback) {
        
    }
    
    func eventFeedbackSubmissionDidFail(_ feedback: EventFeedback) {
        feedbackState = .failed
    }
    
}
