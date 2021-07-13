import EurofurenceModel
import RouterCore

public struct EmbeddedEventRouteable: Routeable {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}
