@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLeavingFeedback_FromEventDetailModule_DirectorShould: XCTestCase {

    func testShowTheLeaveFeedbackFormSheet() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let scheduleNavigationController = context.navigationController(for: context.scheduleModule.stubInterface)
        let event = FakeEvent.random
        context.scheduleModule.simulateDidSelectEvent(event.identifier)
        context.eventDetailModule.simulateLeaveFeedback()
        
        XCTAssertEqual(context.eventFeedbackModule.eventToLeaveFeedbackFor, event.identifier)
        XCTAssertEqual(context.eventFeedbackModule.stubInterface, scheduleNavigationController?.capturedPresentedViewController)
        XCTAssertEqual(context.eventFeedbackModule.stubInterface.modalPresentationStyle, .formSheet)
    }

}
