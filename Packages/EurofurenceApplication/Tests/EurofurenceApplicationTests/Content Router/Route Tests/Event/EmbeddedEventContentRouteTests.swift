import EurofurenceApplication
import EurofurenceModel
import XCTest

class EmbeddedEventContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = EventIdentifier.random
        let content = EmbeddedEventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EmbeddedEventContentRoute(
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
        let content = EmbeddedEventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let eventDetailDelegate = CapturingEventDetailComponentDelegate()
        let route = EmbeddedEventContentRoute(
            eventModuleFactory: eventModuleFactory,
            eventDetailDelegate: eventDetailDelegate,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        eventModuleFactory.simulateLeaveFeedback()
        
        XCTAssertEqual(identifier, eventDetailDelegate.eventToldToLeaveFeedbackFor)
    }

}
