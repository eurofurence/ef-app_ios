import EurofurenceModel

public struct NewsSubrouter: NewsModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func newsModuleDidRequestShowingPrivateMessages() {
        try? router.route(MessagesContentRepresentation())
    }
    
    public func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        try? router.route(AnnouncementContentRepresentation(identifier: announcement))
    }
    
    public func newsModuleDidSelectEvent(_ event: Event) {
        try? router.route(EventContentRepresentation(identifier: event.identifier))
    }
    
    public func newsModuleDidRequestShowingAllAnnouncements() {
        try? router.route(AnnouncementsContentRepresentation())
    }
    
}
