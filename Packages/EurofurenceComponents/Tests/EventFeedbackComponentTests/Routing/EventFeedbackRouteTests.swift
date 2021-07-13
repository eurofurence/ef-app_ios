import EurofurenceModel
import EventFeedbackComponent
import XCTComponentBase
import XCTest
import XCTEventFeedbackComponent

class EventFeedbackRouteTests: XCTestCase {
    
    func testModallyPresentsEventFeedback() {
        let identifier = EventIdentifier.random
        let content = EventFeedbackRouteable(identifier: identifier)
        let eventFeedbackFactory = StubEventFeedbackComponentFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = EventFeedbackRoute(
            eventFeedbackFactory: eventFeedbackFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, eventFeedbackFactory.eventToLeaveFeedbackFor)
        XCTAssertEqual(modalWireframe.presentedModalContentController, eventFeedbackFactory.stubInterface)
    }
    
    func testDismissesControllerWhenCancellingFeedback() {
        let identifier = EventIdentifier.random
        let content = EventFeedbackRouteable(identifier: identifier)
        let eventFeedbackFactory = StubEventFeedbackComponentFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = EventFeedbackRoute(
            eventFeedbackFactory: eventFeedbackFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        eventFeedbackFactory.simulateDismissFeedback()
        
        XCTAssertTrue(eventFeedbackFactory.stubInterface.didDismissPresentedController)
        XCTAssertTrue(eventFeedbackFactory.stubInterface.didDismissUsingAnimations)
    }

}
