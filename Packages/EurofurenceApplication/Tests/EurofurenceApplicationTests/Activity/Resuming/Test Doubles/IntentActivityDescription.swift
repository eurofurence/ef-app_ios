import EurofurenceApplication

struct IntentActivityDescription: ActivityDescription {
    
    var intent: AnyHashable
    
    func describe(to visitor: ActivityDescriptionVisitor) {
        visitor.visitIntent(intent)
    }
    
}
