import EurofurenceModel
import RouterCore

public struct NewsSubrouter: NewsComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func newsModuleDidRequestShowingPrivateMessages() {
        try? router.route(MessagesRouteable())
    }
    
    public func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        try? router.route(AnnouncementRouteable(identifier: announcement))
    }
    
    public func newsModuleDidSelectEvent(_ event: EventIdentifier) {
        try? router.route(EmbeddedEventRouteable(identifier: event))
    }
    
    public func newsModuleDidRequestShowingAllAnnouncements() {
        try? router.route(AnnouncementsRouteable())
    }
    
    public func newsModuleDidRequestShowingSettings(sender: Any) {
        
    }
    
}
