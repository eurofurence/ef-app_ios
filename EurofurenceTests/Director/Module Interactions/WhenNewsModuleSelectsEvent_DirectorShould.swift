@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenNewsModuleSelectsEvent_DirectorShould: XCTestCase {

    func testPushEventDetailModuleOntoNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        let event = FakeEvent.random
        context.newsModule.simulateDidSelectEvent(event)

        XCTAssertEqual(context.eventDetailModule.stubInterface, newsNavigationController?.topViewController)
        XCTAssertEqual(event.identifier, context.eventDetailModule.capturedModel)
    }

}
