import DealerComponent
import EurofurenceModel
import XCTComponentBase
import XCTDealerComponent
import XCTest

class DealerRouteTests: XCTestCase {
    
    func testShowsDetailContentController() {
        let identifier = DealerIdentifier.random
        let content = DealerRouteable(identifier: identifier)
        let dealerModuleFactory = StubDealerDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let route = DealerRoute(
            dealerModuleFactory: dealerModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, dealerModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.replacedDetailContentController, dealerModuleFactory.stubInterface)
    }

}
