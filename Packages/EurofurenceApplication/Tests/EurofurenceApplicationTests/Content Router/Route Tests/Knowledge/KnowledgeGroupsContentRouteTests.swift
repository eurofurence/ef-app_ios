import EurofurenceApplication
import KnowledgeGroupsComponent
import XCTest

class KnowledgeGroupsContentRouteTests: XCTestCase {
    
    func testShowsTab() {
        let tabNavigator = CapturingTabNavigator()
        let route = KnowledgeGroupsContentRoute(tabNavigator: tabNavigator)
        
        XCTAssertFalse(tabNavigator.didMoveToTab)
        
        route.route(KnowledgeGroupsContentRepresentation())
        
        XCTAssertTrue(tabNavigator.didMoveToTab)
    }

}
