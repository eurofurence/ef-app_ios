import Eurofurence
import XCTest

class NewsRouteTests: XCTestCase {
    
    func testRequestsNewsToBecomeVisible() {
        let presentation = CapturingNewsPresentation()
        let route = NewsContentRoute(newsPresentation: presentation)
        
        XCTAssertFalse(presentation.didShowNews)
        
        route.route(NewsContentRepresentation())
        
        XCTAssertTrue(presentation.didShowNews)
    }

}
