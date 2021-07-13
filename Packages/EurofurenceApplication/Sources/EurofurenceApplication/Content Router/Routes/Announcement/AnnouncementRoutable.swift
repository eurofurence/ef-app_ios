import EurofurenceModel
import RouterCore

public struct AnnouncementRouteable: Routeable {
    
    public var identifier: AnnouncementIdentifier
    
    public init(identifier: AnnouncementIdentifier) {
        self.identifier = identifier
    }
    
}
