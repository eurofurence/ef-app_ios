import EurofurenceModel
import XCTest

class HardcodedCompanionAppURLRequestFactoryTests: XCTestCase {

    func testReturnUnauthenticatedURLRequest() throws {
        let conventionIdentifier = ConventionIdentifier(identifier: "CID")
        let requestFactory = HardcodedCompanionAppURLRequestFactory(conventionIdentifier: conventionIdentifier)
        let urlString = "https://app.eurofurence.org/CID/companion/#/login?embedded=true&returnPath=/&token="
        let url = try XCTUnwrap(URL(string: urlString))
        let expected = URLRequest(url: url)
        
        XCTAssertEqual(expected, requestFactory.makeAdditionalServicesRequest(authenticationToken: nil))
    }
    
    func testReturnAuthenticatedURLRequest() throws {
        let conventionIdentifier = ConventionIdentifier(identifier: "CID")
        let requestFactory = HardcodedCompanionAppURLRequestFactory(conventionIdentifier: conventionIdentifier)
        let urlString = "https://app.eurofurence.org/CID/companion/#/login?embedded=true&returnPath=/&token=Hello"
        let url = try XCTUnwrap(URL(string: urlString))
        let expected = URLRequest(url: url)
        
        XCTAssertEqual(
            expected,
            requestFactory.makeAdditionalServicesRequest(authenticationToken: "Hello")
        )
    }

}
