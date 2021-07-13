import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTRouter

class NavigateFromAnnouncementsToAnnouncementTests: XCTestCase {
    
    func testRoutesToAnnouncementContent() {
        let router = FakeContentRouter()
        let navigator = NavigateFromAnnouncementsToAnnouncement(router: router)
        let announcement = AnnouncementIdentifier.random
        navigator.announcementsComponentDidSelectAnnouncement(announcement)
        
        let expected = AnnouncementRouteable(identifier: announcement)
        router.assertRouted(to: expected)
    }

}
