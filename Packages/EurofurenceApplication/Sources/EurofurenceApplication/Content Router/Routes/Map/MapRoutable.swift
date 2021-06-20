import EurofurenceModel
import RouterCore

public struct MapRouteable: Routeable {
    
    public var identifier: MapIdentifier
    
    public init(identifier: MapIdentifier) {
        self.identifier = identifier
    }
    
}
