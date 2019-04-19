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
        let presentedViewController = scheduleNavigationController?.capturedPresentedViewController as? UINavigationController
        
        XCTAssertEqual(context.eventFeedbackModule.eventToLeaveFeedbackFor, event.identifier)
        XCTAssertEqual(context.eventFeedbackModule.stubInterface, presentedViewController?.topViewController)
        XCTAssertEqual(presentedViewController?.modalPresentationStyle, .formSheet)
    }
    
    func testDismissTheFeedbackWhenToldTo() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let scheduleNavigationController = context.navigationController(for: context.scheduleModule.stubInterface)
        let event = FakeEvent.random
        context.scheduleModule.simulateDidSelectEvent(event.identifier)
        context.eventDetailModule.simulateLeaveFeedback()
        context.eventFeedbackModule.simulateDismissFeedback()
        let presentedViewController = scheduleNavigationController?.capturedPresentedViewController as? CapturingNavigationController
        
        XCTAssertEqual(true, presentedViewController?.dismissed)
    }

}
