import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEventDetailComponent

class EventContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = EventIdentifier.random
        let content = EventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EventContentRoute(
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
        let content = EventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let eventDetailDelegate = CapturingEventDetailComponentDelegate()
        let route = EventContentRoute(
            eventModuleFactory: eventModuleFactory,
            eventDetailDelegate: eventDetailDelegate,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        eventModuleFactory.simulateLeaveFeedback()
        
        XCTAssertEqual(identifier, eventDetailDelegate.eventToldToLeaveFeedbackFor)
    }

}
