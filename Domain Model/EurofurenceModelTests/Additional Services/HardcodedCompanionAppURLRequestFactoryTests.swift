import EurofurenceModel
import XCTest

class HardcodedCompanionAppURLRequestFactoryTests: XCTestCase {

    func testReturnUnauthenticatedURLRequest() {
        let requestFactory = HardcodedCompanionAppURLRequestFactory()
        let expected = URLRequest(url: unwrap(URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token=")))
        
        XCTAssertEqual(expected, requestFactory.makeAdditionalServicesRequest(authenticationToken: nil))
    }
    
    func testReturnAuthenticatedURLRequest() {
        let requestFactory = HardcodedCompanionAppURLRequestFactory()
        let expected = URLRequest(url: unwrap(URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token=Hello")))
        let authenticationTokenInURL = "Hello"
        
        XCTAssertEqual(expected, requestFactory.makeAdditionalServicesRequest(authenticationToken: authenticationTokenInURL))
    }

}
