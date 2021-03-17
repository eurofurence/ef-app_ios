import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class NewsSubrouterTests: XCTestCase {
    
    var router: FakeContentRouter!
    var subrouter: NewsSubrouter!
    
    override func setUp() {
        super.setUp()
        
        router = FakeContentRouter()
        subrouter = NewsSubrouter(router: router)
    }
    
    func testShowingPrivateMessages() {
        subrouter.newsModuleDidRequestShowingPrivateMessages()
        router.assertRouted(to: MessagesContentRepresentation())
    }
    
    func testShowingAnnouncement() {
        let announcement = AnnouncementIdentifier.random
        subrouter.newsModuleDidSelectAnnouncement(announcement)
        
        router.assertRouted(to: AnnouncementContentRepresentation(identifier: announcement))
    }
    
    func testShowingEvent() {
        let event = FakeEvent.random
        subrouter.newsModuleDidSelectEvent(event)
        
        router.assertRouted(to: EmbeddedEventContentRepresentation(identifier: event.identifier))
    }
    
    func testShowingAnnouncements() {
        subrouter.newsModuleDidRequestShowingAllAnnouncements()
        router.assertRouted(to: AnnouncementsContentRepresentation())
    }

}
