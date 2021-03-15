import EurofurenceApplication

class CapturingEventFeedbackComponentDelegate: EventFeedbackComponentDelegate {
    
    private(set) var dismissed = false
    func eventFeedbackCancelled() {
        dismissed = true
    }
    
}
