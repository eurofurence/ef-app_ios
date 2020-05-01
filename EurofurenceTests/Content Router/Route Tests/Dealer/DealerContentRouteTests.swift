import Eurofurence
import EurofurenceModel
import XCTest

class DealerContentRouteTests: XCTestCase {
    
    func testRevealsDetailContentController() {
        let identifier = DealerIdentifier.random
        let content = DealerContentRepresentation(identifier: identifier)
        let dealerModuleFactory = StubDealerDetailModuleProviding()
        let contentWireframe = CapturingContentWireframe()
        let route = DealerContentRoute(
            dealerModuleFactory: dealerModuleFactory,
            contentWireframe: contentWireframe
        )
        
        route.route(content)
        
        XCTAssertEqual(identifier, dealerModuleFactory.capturedModel)
        XCTAssertEqual(contentWireframe.presentedDetailContentController, dealerModuleFactory.stubInterface)
    }

}
