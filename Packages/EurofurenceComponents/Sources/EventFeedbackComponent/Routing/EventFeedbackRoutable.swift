import EurofurenceModel
import RouterCore

public struct EventFeedbackRouteable: Routeable {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}
