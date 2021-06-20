import DealersComponent
import DealersJourney
import XCTest

class DealersRouteTests: XCTestCase {
    
    func testShowsDealers() {
        let presentation = CapturingDealersPresentation()
        let route = DealersRoute(presentation: presentation)
        
        XCTAssertFalse(presentation.didShowDealers)
        
        route.route(DealersRouteable())
        
        XCTAssertTrue(presentation.didShowDealers)
    }
    
}
