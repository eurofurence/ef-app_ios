import Eurofurence
import EurofurenceModel
import XCTest

class EventContentRouteTests: XCTestCase {
    
    func testCurrentContextRevealsUsingShow() {
        let identifier = EventIdentifier.random
        let content = EventContentRepresentation(identifier: identifier)
        let eventModuleFactory = StubEventDetailModuleFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EventContentRoute(
            eventModuleFactory: eventModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, eventModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, eventModuleFactory.stubInterface)
    }

}
