import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest

class AnnouncementsRouteTests: XCTestCase {
    
    func testShowsContentController() {
        let content = AnnouncementsRouteable()
        let announcementsComponentFactory = StubAnnouncementsComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = AnnouncementsRoute(
            announcementsComponentFactory: announcementsComponentFactory,
            contentWireframe: contentWireframe,
            delegate: CapturingAnnouncementsComponentDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(announcementsComponentFactory.stubInterface, contentWireframe.presentedPrimaryContentController)
    }
    
    func testPropogatesDelegateEvents() {
        let content = AnnouncementsRouteable()
        let announcementsComponentFactory = StubAnnouncementsComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingAnnouncementsComponentDelegate()
        let route = AnnouncementsRoute(
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
