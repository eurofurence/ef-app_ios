import Foundation

public protocol EventFeedbackDelegate {
    
    func eventFeedbackSubmissionDidFinish(_ feedback: EventFeedback)
    func eventFeedbackSubmissionDidFail(_ feedback: EventFeedback)
    
}
