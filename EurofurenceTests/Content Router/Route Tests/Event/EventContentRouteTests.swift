import Eurofurence
import EurofurenceModel
import XCTest

class EventContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = EventIdentifier.random
        let content = EventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailModuleFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EventContentRoute(
            eventModuleFactory: eventModuleFactory,
            eventDetailDelegate: CapturingEventDetailModuleDelegate(),
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, eventModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, eventModuleFactory.stubInterface)
    }
    
    func testPropogatesHandlingForReviewRequest() {
        let identifier = EventIdentifier.random
        let content = EventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailModuleFactory()
        let contentWireframe = CapturingContentWireframe()
        let eventDetailDelegate = CapturingEventDetailModuleDelegate()
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
