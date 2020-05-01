import EurofurenceModel

public struct NavigateFromAnnouncementsToAnnouncement: AnnouncementsModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func announcementsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        try? router.route(AnnouncementContentRepresentation(identifier: announcement))
    }
    
}
