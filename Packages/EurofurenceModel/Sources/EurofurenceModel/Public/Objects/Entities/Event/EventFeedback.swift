import Foundation

public protocol EventFeedback: AnyObject {
    
    var feedback: String { get set }
    var starRating: Int { get set }
    
    func submit(_ delegate: EventFeedbackDelegate)
    
}
