import Foundation

public protocol EventFeedback: class {
    
    var feedback: String { get set }
    var starRating: Int { get set }
    
    func submit(_ delegate: EventFeedbackDelegate)
    
}
