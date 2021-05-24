import DealersComponent
import EurofurenceApplication
import XCTest

class ShowDealersRouteTests: XCTestCase {
    
    func testActivatesTab() {
        let tabNavigator = CapturingTabNavigator()
        let route = ShowDealersRoute(tabNavigator: tabNavigator)
        
        XCTAssertFalse(tabNavigator.didMoveToTab)
        
        route.route(DealersContentRepresentation())
        
        XCTAssertTrue(tabNavigator.didMoveToTab)
    }
    
}
