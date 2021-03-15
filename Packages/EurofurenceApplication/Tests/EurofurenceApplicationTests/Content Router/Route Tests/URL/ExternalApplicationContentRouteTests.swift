import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class ExternalApplicationContentRouteTests: XCTestCase {
    
    func testOpensURL() {
        let urlOpener = CapturingURLOpener()
        let route = ExternalApplicationContentRoute(urlOpener: urlOpener)
        let url = URL.random
        route.route(ExternalApplicationContentRepresentation(url: url))
        
        XCTAssertEqual(url, urlOpener.capturedURLToOpen)
    }

}
