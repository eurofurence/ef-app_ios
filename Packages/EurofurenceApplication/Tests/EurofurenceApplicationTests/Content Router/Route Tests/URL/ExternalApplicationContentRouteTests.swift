import ComponentBase
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class ExternalApplicationContentRouteTests: XCTestCase {
    
    func testOpensURL() {
        let urlOpener = CapturingURLOpener()
        let route = ExternalApplicationContentRoute(urlOpener: urlOpener)
        let url = URL.random
        route.route(ExternalApplicationContentRepresentation(url: url))
        
        XCTAssertEqual(url, urlOpener.capturedURLToOpen)
    }

}
