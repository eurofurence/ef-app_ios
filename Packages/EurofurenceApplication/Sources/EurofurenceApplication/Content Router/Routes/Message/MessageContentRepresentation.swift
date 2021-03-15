import EurofurenceModel

public struct MessageContentRepresentation: ContentRepresentation {
    
    public var identifier: MessageIdentifier
    
    public init(identifier: MessageIdentifier) {
        self.identifier = identifier
    }
    
}
