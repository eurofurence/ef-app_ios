import EurofurenceApplication
import XCTest

class NewsRouteTests: XCTestCase {
    
    func testRequestsNewsToBecomeVisible() {
        let presentation = CapturingNewsPresentation()
        let route = NewsRoute(newsPresentation: presentation)
        
        XCTAssertFalse(presentation.didShowNews)
        
        route.route(NewsRouteable())
        
        XCTAssertTrue(presentation.didShowNews)
    }

}
