import EurofurenceModel
import Foundation

public struct EmbeddedEventContentRepresentation: ContentRepresentation {
    
    public var identifier: EventIdentifier
    
    public init(identifier: EventIdentifier) {
        self.identifier = identifier
    }
    
}
