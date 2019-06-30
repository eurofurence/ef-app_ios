import Foundation

struct SystemActivityDescription: ActivityDescription {
    
    var userActivity: NSUserActivity
    
    func describe(to visitor: ActivityDescriptionVisitor) {
        if let intent = userActivity.interaction?.intent {
            visitor.visitIntent(intent)
        }
    }
    
}
