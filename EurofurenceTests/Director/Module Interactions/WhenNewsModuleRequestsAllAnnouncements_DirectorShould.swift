@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenNewsModuleRequestsAllAnnouncements_DirectorShould: XCTestCase {

    func testPushTheAnnouncementsModuleOntoTheNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        context.newsModule.simulateAllAnnouncementsDisplayRequested()

        XCTAssertEqual(context.announcementsModule.stubInterface, newsNavigationController?.topViewController)
    }

}
