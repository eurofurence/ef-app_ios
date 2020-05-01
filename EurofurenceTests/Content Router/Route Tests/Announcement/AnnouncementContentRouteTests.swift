import Eurofurence
import EurofurenceModel
import XCTest

class AnnouncementContentRouteTests: XCTestCase {
    
    func testShowsContentControllerForAnnouncement() {
        let identifier = AnnouncementIdentifier.random
        let content = AnnouncementContentRepresentation(identifier: identifier)
        let announcementModuleFactory = StubAnnouncementDetailModuleFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = AnnouncementContentRoute(
            announcementModuleFactory: announcementModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, announcementModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedNewsContentController, announcementModuleFactory.stubInterface)
    }

}
