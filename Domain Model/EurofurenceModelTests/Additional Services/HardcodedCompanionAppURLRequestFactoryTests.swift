import EurofurenceModel
import XCTest

class HardcodedCompanionAppURLRequestFactoryTests: XCTestCase {

    func testReturnUnauthenticatedURLRequest() throws {
        let requestFactory = HardcodedCompanionAppURLRequestFactory()
        let urlString = "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/&token="
        let url = try XCTUnwrap(URL(string: urlString))
        let expected = URLRequest(url: url)
        
        XCTAssertEqual(expected, requestFactory.makeAdditionalServicesRequest(authenticationToken: nil))
    }
    
    func testReturnAuthenticatedURLRequest() throws {
        let requestFactory = HardcodedCompanionAppURLRequestFactory()
        let urlString = "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/&token=Hello"
        let url = try XCTUnwrap(URL(string: urlString))
        let expected = URLRequest(url: url)
        
        XCTAssertEqual(
            expected,
            requestFactory.makeAdditionalServicesRequest(authenticationToken: "Hello")
        )
    }

}
