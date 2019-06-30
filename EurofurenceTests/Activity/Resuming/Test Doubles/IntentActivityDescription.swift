@testable import Eurofurence

struct IntentActivityDescription: ActivityDescription {
    
    var intent: Any
    
    func describe(to visitor: ActivityDescriptionVisitor) {
        visitor.visitIntent(intent)
    }
    
}
