import Foundation
import Intents

public struct SystemActivityDescription: ActivityDescription {
    
    private let userActivity: NSUserActivity
    
    public init(userActivity: NSUserActivity) {
        self.userActivity = userActivity
    }
    
    public func describe(to visitor: ActivityDescriptionVisitor) {
        if let intent = userActivity.interaction?.intent {
            visitor.visitIntent(intent)
        }
        
        if let url = userActivity.webpageURL {
            visitor.visitURL(url)
        }
    }
    
}
