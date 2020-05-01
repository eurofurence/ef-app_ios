import EurofurenceModel

public struct EventContentRepresentation: ContentRepresentation {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}
