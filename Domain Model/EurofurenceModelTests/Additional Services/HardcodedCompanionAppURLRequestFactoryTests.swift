import EurofurenceModel
import XCTest

class HardcodedCompanionAppURLRequestFactoryTests: XCTestCase {

    func testReturnUnauthenticatedURLRequest() {
        let requestFactory = HardcodedCompanionAppURLRequestFactory()
        let expected = URLRequest(url: URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/&token=").unsafelyUnwrapped)
        
        XCTAssertEqual(expected, requestFactory.makeAdditionalServicesRequest(authenticationToken: nil))
    }
    
    func testReturnAuthenticatedURLRequest() {
        let requestFactory = HardcodedCompanionAppURLRequestFactory()
        let expected = URLRequest(url: URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/&token=Hello").unsafelyUnwrapped)
        let authenticationTokenInURL = "Hello"
        
        XCTAssertEqual(expected, requestFactory.makeAdditionalServicesRequest(authenticationToken: authenticationTokenInURL))
    }

}
