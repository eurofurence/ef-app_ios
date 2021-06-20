import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTDealerComponent
import XCTest

class EmbeddedDealerRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = DealerIdentifier.random
        let content = EmbeddedDealerRouteable(identifier: identifier)
        let dealerModuleFactory = StubDealerDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = EmbeddedDealerRoute(
            dealerModuleFactory: dealerModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, dealerModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, dealerModuleFactory.stubInterface)
    }

}
