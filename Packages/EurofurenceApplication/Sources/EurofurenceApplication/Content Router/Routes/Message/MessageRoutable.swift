import EurofurenceModel
import RouterCore

public struct MessageRouteable: Routeable {
    
    public var identifier: MessageIdentifier
    
    public init(identifier: MessageIdentifier) {
        self.identifier = identifier
    }
    
}
