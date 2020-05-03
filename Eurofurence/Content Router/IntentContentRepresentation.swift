import Foundation

public struct IntentContentRepresentation: ContentRepresentation {
    
    public var intent: AnyHashable
    
    public init(intent: AnyHashable) {
        self.intent = intent
    }
    
}
