import EventFeedbackComponent

class CapturingEventFeedbackComponentDelegate: EventFeedbackComponentDelegate {
    
    private(set) var dismissed = false
    func eventFeedbackCancelled() {
        dismissed = true
    }
    
}
