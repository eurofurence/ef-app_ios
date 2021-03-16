import EurofurenceComponentBase
import EurofurenceModel

public struct NavigateFromAnnouncementsToAnnouncement: AnnouncementsComponentDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func announcementsComponentDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        try? router.route(AnnouncementContentRepresentation(identifier: announcement))
    }
    
}
