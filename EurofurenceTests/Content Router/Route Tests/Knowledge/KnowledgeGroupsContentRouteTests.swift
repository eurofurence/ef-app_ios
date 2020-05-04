import Eurofurence
import XCTest

class KnowledgeGroupsContentRouteTests: XCTestCase {
    
    func testShowsTab() {
        let tabNavigator = CapturingTabSwapper()
        let route = KnowledgeGroupsContentRoute(tabNavigator: tabNavigator)
        
        XCTAssertFalse(tabNavigator.didMoveToTab)
        
        route.route(KnowledgeGroupsContentRepresentation())
        
        XCTAssertTrue(tabNavigator.didMoveToTab)
    }

}
