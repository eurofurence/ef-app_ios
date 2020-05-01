import Eurofurence
import EurofurenceModel
import XCTest

class NavigateFromAnnouncementsToAnnouncementTests: XCTestCase {
    
    func testRoutesToAnnouncementContent() {
        let router = FakeContentRouter()
        let navigator = NavigateFromAnnouncementsToAnnouncement(router: router)
        let announcement = AnnouncementIdentifier.random
        navigator.announcementsModuleDidSelectAnnouncement(announcement)
        
        let expected = AnnouncementContentRepresentation(identifier: announcement)
        router.assertRouted(to: expected)
    }

}
