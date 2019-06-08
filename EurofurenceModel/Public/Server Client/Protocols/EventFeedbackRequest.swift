import Foundation

public struct EventFeedbackRequest: Hashable {
    
    public var id: String
    public var starRating: Int
    public var feedback: String
    
    public init(id: String, rating: Int, feedback: String) {
        self.id = id
        self.starRating = rating
        self.feedback = feedback
    }
    
}
