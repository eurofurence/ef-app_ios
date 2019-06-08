import Foundation

public protocol EventFeedback {
    
    var feedback: String { get set }
    var starRating: Int { get set }
    
    func submit(_ delegate: EventFeedbackDelegate)
    
}
