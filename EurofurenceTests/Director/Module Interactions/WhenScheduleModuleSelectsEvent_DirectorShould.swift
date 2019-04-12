@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenScheduleModuleSelectsEvent_DirectorShould: XCTestCase {

    func testPushEventDetailModuleOntoScheduleNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let scheduleNavigationController = context.navigationController(for: context.scheduleModule.stubInterface)
        let event = FakeEvent.random
        context.scheduleModule.simulateDidSelectEvent(event.identifier)

        XCTAssertEqual(context.eventDetailModule.stubInterface, scheduleNavigationController?.topViewController)
        XCTAssertEqual(event.identifier, context.eventDetailModule.capturedModel)
    }

}
