import ComponentBase
import EurofurenceModel
import Foundation

public struct DealerContentRepresentation: ContentRepresentation {
    
    public var identifier: DealerIdentifier
    
    public init(identifier: DealerIdentifier) {
        self.identifier = identifier
    }
    
}
