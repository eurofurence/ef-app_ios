import ComponentBase
import EurofurenceModel

public struct AnnouncementContentRepresentation: ContentRepresentation {
    
    public var identifier: AnnouncementIdentifier
    
    public init(identifier: AnnouncementIdentifier) {
        self.identifier = identifier
    }
    
}
