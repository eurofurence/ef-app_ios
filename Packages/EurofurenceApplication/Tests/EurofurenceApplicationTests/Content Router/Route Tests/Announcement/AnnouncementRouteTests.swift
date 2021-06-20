import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest

class AnnouncementRouteTests: XCTestCase {
    
    func testShowsDetailContentControllerForAnnouncement() {
        let identifier = AnnouncementIdentifier.random
        let content = AnnouncementRouteable(identifier: identifier)
        let announcementModuleFactory = StubAnnouncementDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = AnnouncementRoute(
            announcementModuleFactory: announcementModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, announcementModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.replacedDetailContentController, announcementModuleFactory.stubInterface)
    }

}
