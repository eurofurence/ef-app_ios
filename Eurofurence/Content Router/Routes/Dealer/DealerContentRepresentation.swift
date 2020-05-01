import EurofurenceModel

public struct DealerContentRepresentation: ContentRepresentation {
    
    public var identifier: DealerIdentifier
    
    public init(identifier: DealerIdentifier) {
        self.identifier = identifier
    }
    
}
