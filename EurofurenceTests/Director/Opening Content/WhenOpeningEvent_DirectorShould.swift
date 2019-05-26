@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningEvent_DirectorShould: XCTestCase {

    func testPushEventDetailModuleOntoScheduleNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let scheduleNavigationController = context.navigationController(for: context.scheduleModule.stubInterface)
        let event = EventIdentifier.random
        context.director.openEvent(event)
        
        XCTAssertEqual(context.eventDetailModule.stubInterface, scheduleNavigationController?.topViewController)
        XCTAssertEqual(event, context.eventDetailModule.capturedModel)
    }

}
