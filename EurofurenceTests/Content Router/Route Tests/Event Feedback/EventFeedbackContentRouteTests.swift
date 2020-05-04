import Eurofurence
import EurofurenceModel
import XCTest

class EventFeedbackContentRouteTests: XCTestCase {
    
    func testModallyPresentsEventFeedback() {
        let identifier = EventIdentifier.random
        let content = EventFeedbackContentRepresentation(identifier: identifier)
        let eventFeedbackFactory = StubEventFeedbackModuleProviding()
        let modalWireframe = CapturingModalWireframe()
        let route = EventFeedbackContentRoute(
            eventFeedbackFactory: eventFeedbackFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, eventFeedbackFactory.eventToLeaveFeedbackFor)
        XCTAssertEqual(modalWireframe.presentedModalContentController, eventFeedbackFactory.stubInterface)
    }
    
    func testDismissesControllerWhenCancellingFeedback() {
        let identifier = EventIdentifier.random
        let content = EventFeedbackContentRepresentation(identifier: identifier)
        let eventFeedbackFactory = StubEventFeedbackModuleProviding()
        let modalWireframe = CapturingModalWireframe()
        let route = EventFeedbackContentRoute(
            eventFeedbackFactory: eventFeedbackFactory,
            modalWireframe: modalWireframe
        )
        
        route.route(content)
        eventFeedbackFactory.simulateDismissFeedback()
        
        XCTAssertTrue(eventFeedbackFactory.stubInterface.didDismissPresentedController)
        XCTAssertTrue(eventFeedbackFactory.stubInterface.didDismissUsingAnimations)
    }

}
