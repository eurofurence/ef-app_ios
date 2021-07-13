import EurofurenceModel
import EventDetailComponent
import XCTComponentBase
import XCTest
import XCTEventDetailComponent

class EventRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = EventIdentifier.random
        let content = EventRouteable(identifier: identifier)
        let eventModuleFactory = StubEventDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EventRoute(
            eventModuleFactory: eventModuleFactory,
            eventDetailDelegate: CapturingEventDetailComponentDelegate(),
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, eventModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.replacedDetailContentController, eventModuleFactory.stubInterface)
    }
    
    func testPropogatesHandlingForReviewRequest() {
        let identifier = EventIdentifier.random
        let content = EventRouteable(identifier: identifier)
        let eventModuleFactory = StubEventDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let eventDetailDelegate = CapturingEventDetailComponentDelegate()
        let route = EventRoute(
            eventModuleFactory: eventModuleFactory,
            eventDetailDelegate: eventDetailDelegate,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        eventModuleFactory.simulateLeaveFeedback()
        
        XCTAssertEqual(identifier, eventDetailDelegate.eventToldToLeaveFeedbackFor)
    }

}
