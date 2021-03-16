import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceComponentBase

class NavigateFromAnnouncementsToAnnouncementTests: XCTestCase {
    
    func testRoutesToAnnouncementContent() {
        let router = FakeContentRouter()
        let navigator = NavigateFromAnnouncementsToAnnouncement(router: router)
        let announcement = AnnouncementIdentifier.random
        navigator.announcementsComponentDidSelectAnnouncement(announcement)
        
        let expected = AnnouncementContentRepresentation(identifier: announcement)
        router.assertRouted(to: expected)
    }

}
