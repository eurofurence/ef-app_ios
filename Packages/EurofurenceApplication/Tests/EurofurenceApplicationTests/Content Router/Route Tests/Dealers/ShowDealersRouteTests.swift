import EurofurenceApplication
import XCTest

class ShowDealersRouteTests: XCTestCase {
    
    func testActivatesTab() {
        let tabActivator = CapturingTabWireframe()
        let route = ShowDealersRoute(tabActivator: tabActivator)
        
        XCTAssertFalse(tabActivator.activated)
        
        route.route(DealersContentRepresentation())
        
        XCTAssertTrue(tabActivator.activated)
    }
    
}
