import EurofurenceModel

public struct ViewEventIntentDefinition: Hashable {
    
    public var identifier: EventIdentifier
    public var eventName: String
    
    public init(identifier: EventIdentifier, eventName: String) {
        self.identifier = identifier
        self.eventName = eventName
    }
    
}
