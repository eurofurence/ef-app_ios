import EurofurenceModel
import RouterCore

public struct EventRouteable: Routeable {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}
