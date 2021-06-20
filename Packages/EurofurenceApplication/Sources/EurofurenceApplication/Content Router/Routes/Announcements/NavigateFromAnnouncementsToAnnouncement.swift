import EurofurenceModel
import RouterCore

public struct NavigateFromAnnouncementsToAnnouncement: AnnouncementsComponentDelegate {
    
    private let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    public func announcementsComponentDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        try? router.route(AnnouncementRouteable(identifier: announcement))
    }
    
}
