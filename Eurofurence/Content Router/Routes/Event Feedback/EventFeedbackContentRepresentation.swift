import EurofurenceModel

public struct EventFeedbackContentRepresentation: ContentRepresentation {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}
