import EurofurenceModel
import RouterCore

public struct DealerRouteable: Routeable {
    
    public var identifier: DealerIdentifier
    
    public init(identifier: DealerIdentifier) {
        self.identifier = identifier
    }
    
}
