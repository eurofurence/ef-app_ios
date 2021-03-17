import ComponentBase
import EurofurenceModel

public struct EmbeddedDealerContentRepresentation: ContentRepresentation {
    
    public var identifier: DealerIdentifier
    
    public init(identifier: DealerIdentifier) {
        self.identifier = identifier
    }
    
}
