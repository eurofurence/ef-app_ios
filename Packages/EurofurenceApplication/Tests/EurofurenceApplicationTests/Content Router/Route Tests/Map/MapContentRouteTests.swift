import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class MapContentRouteTests: XCTestCase {
    
    func testShowsMapDetail() {
        let map = MapIdentifier.random
        let content = MapContentRepresentation(identifier: map)
        let mapModuleProviding = StubMapDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingMapDetailComponentDelegate()
        let route = MapContentRoute(
            mapModuleProviding: mapModuleProviding,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        XCTAssertEqual(map, mapModuleProviding.capturedModel)
        XCTAssertEqual(mapModuleProviding.stubInterface, contentWireframe.replacedDetailContentController)
    }
    
    func testPropogatesDealerSelectedEvents() {
        let map = MapIdentifier.random
        let content = MapContentRepresentation(identifier: map)
        let mapModuleProviding = StubMapDetailComponentFactory()
        let contentWireframe = CapturingContentWireframe()
        let delegate = CapturingMapDetailComponentDelegate()
        let route = MapContentRoute(
            mapModuleProviding: mapModuleProviding,
            contentWireframe: contentWireframe,
            delegate: delegate
        )
        
        route.route(content)
        
        let dealer = DealerIdentifier.random
        mapModuleProviding.simulateDidSelectDealer(dealer)
        
        XCTAssertEqual(dealer, delegate.capturedDealerToShow)
    }

}
