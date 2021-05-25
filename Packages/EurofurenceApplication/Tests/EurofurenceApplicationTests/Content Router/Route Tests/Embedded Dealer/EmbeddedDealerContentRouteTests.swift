import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTDealerComponent
import XCTest

class EmbeddedDealerContentRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = DealerIdentifier.random
        let content = EmbeddedDealerContentRepresentation(identifier: identifier)
        let dealerModuleFactory = StubDealerDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EmbeddedDealerContentRoute(
            dealerModuleFactory: dealerModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, dealerModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, dealerModuleFactory.stubInterface)
    }

}
