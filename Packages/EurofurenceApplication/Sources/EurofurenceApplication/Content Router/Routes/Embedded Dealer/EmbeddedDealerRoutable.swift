import EurofurenceModel
import RouterCore

public struct EmbeddedDealerRouteable: Routeable {
    
    public var identifier: DealerIdentifier
    
    public init(identifier: DealerIdentifier) {
        self.identifier = identifier
    }
    
}
