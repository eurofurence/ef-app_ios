import Eurofurence
import EurofurenceModel
import XCTest

class AnnouncementsContentRouteTests: XCTestCase {
    
    func testShowsContentController() {
        let content = AnnouncementsContentRepresentation()
        let announcementsModuleProviding = StubAnnouncementsModuleProviding()
        let contentWireframe = CapturingContentWireframe()
        let route = AnnouncementsContentRoute(
            announcementsModuleProviding: announcementsModuleProviding,
            contentWireframe: contentWireframe,
            delegate: CapturingAnnouncementsModuleDelegate()
        )
        
        route.route(content)
        
        XCTAssertEqual(announcementsModuleProviding.stubInterface, contentWireframe.presentedMasterContentController)
    }
    
    func testPropogatesDelegateEvents() {
        let content = AnnouncementsContentRepresentation()
        let announcementsModuleProviding = StubAnnouncementsModuleProviding()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingAnnouncementsModuleDelegate()
        let route = AnnouncementsContentRoute(
            announcementsModuleProviding: announcementsModuleProviding,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        let selectedAnnouncement = AnnouncementIdentifier.random
        announcementsModuleProviding.simulateDidSelectAnnouncement(selectedAnnouncement)
        
        XCTAssertEqual(selectedAnnouncement, delegate.capturedSelectedAnnouncement)
    }

}
