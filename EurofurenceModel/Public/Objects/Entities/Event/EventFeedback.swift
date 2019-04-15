import Foundation

public protocol EventFeedback {
    
    var feedback: String { get set }
    var rating: Int { get set }
    
    func submit(_ delegate: EventFeedbackDelegate)
    
}
