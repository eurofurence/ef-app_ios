@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenNewsModuleSelectsAnnouncement_DirectorShould: XCTestCase {

    func testPushAnnouncementDetailModuleOntoNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        let announcement = AnnouncementIdentifier.random
        context.newsModule.simulateDidSelectAnnouncement(announcement)

        XCTAssertEqual(context.announcementDetailModule.stubInterface, newsNavigationController?.topViewController)
        XCTAssertEqual(announcement, context.announcementDetailModule.capturedModel)
    }

}
