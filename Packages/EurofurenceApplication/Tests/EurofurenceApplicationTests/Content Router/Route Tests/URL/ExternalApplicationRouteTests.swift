import ComponentBase
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class ExternalApplicationRouteTests: XCTestCase {
    
    func testOpensURL() {
        let urlOpener = CapturingURLOpener()
        let route = ExternalApplicationRoute(urlOpener: urlOpener)
        let url = URL.random
        route.route(ExternalApplicationRouteable(url: url))
        
        XCTAssertEqual(url, urlOpener.capturedURLToOpen)
    }

}
