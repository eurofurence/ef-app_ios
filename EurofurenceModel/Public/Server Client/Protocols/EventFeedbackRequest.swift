import Foundation

public struct EventFeedbackRequest: Hashable {
    
    public var id: String
    public var rating: Int
    public var feedback: String
    
    public init(id: String, rating: Int, feedback: String) {
        self.id = id
        self.rating = rating
        self.feedback = feedback
    }
    
}
