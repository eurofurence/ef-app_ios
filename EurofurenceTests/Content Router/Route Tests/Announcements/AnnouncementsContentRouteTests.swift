import Eurofurence
import EurofurenceModel
import XCTest

class AnnouncementsContentRouteTests: XCTestCase {
    
    func testShowsContentController() {
        let content = AnnouncementsContentRepresentation()
        let announcementsComponentFactory = StubAnnouncementsComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = AnnouncementsContentRoute(
            announcementsComponentFactory: announcementsComponentFactory,
            contentWireframe: contentWireframe,
            delegate: CapturingAnnouncementsComponentDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(announcementsComponentFactory.stubInterface, contentWireframe.presentedPrimaryContentController)
    }
    
    func testPropogatesDelegateEvents() {
        let content = AnnouncementsContentRepresentation()
        let announcementsComponentFactory = StubAnnouncementsComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingAnnouncementsComponentDelegate()
        let route = AnnouncementsContentRoute(
            announcementsComponentFactory: announcementsComponentFactory,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        let selectedAnnouncement = AnnouncementIdentifier.random
        announcementsComponentFactory.simulateDidSelectAnnouncement(selectedAnnouncement)
        
        XCTAssertEqual(selectedAnnouncement, delegate.capturedSelectedAnnouncement)
    }

}
