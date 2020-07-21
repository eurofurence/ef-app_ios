import Eurofurence
import EurofurenceModel
import XCTest

class AnnouncementContentRouteTests: XCTestCase {
    
    func testShowsDetailContentControllerForAnnouncement() {
        let identifier = AnnouncementIdentifier.random
        let content = AnnouncementContentRepresentation(identifier: identifier)
        let announcementModuleFactory = StubAnnouncementDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let tabNavigator = CapturingTabSwapper()
        let route = AnnouncementContentRoute(
            announcementModuleFactory: announcementModuleFactory,
            announcementsTabNavigator: tabNavigator,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, announcementModuleFactory.capturedModel)
        XCTAssertTrue(tabNavigator.didMoveToTab)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, announcementModuleFactory.stubInterface)
    }

}
