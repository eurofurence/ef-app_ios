import EurofurenceComponentBase
import EurofurenceModel

public struct MapContentRepresentation: ContentRepresentation {
    
    public var identifier: MapIdentifier
    
    public init(identifier: MapIdentifier) {
        self.identifier = identifier
    }
    
}
