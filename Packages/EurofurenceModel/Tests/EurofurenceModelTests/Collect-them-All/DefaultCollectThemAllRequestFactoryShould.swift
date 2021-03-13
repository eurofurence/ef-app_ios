import EurofurenceModel
import XCTest

class DefaultCollectThemAllRequestFactoryShould: XCTestCase {
    
    private let baseURL = "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token="

    func testProduceExpectedAnonymousRequest() throws {
        let factory = DefaultCollectThemAllRequestFactory()
        let anonymousRequest = factory.makeAnonymousGameURLRequest()
        let expectedURL = try XCTUnwrap(URL(string: "\(baseURL)empty"))

        XCTAssertEqual(expectedURL, anonymousRequest.url)
    }

    func testProduceExpectedAuthenticatedRequest() throws {
        let credential = Credential.randomValidCredential
        
        let factory = DefaultCollectThemAllRequestFactory()
        let authenticatedRequest = factory.makeAuthenticatedGameURLRequest(credential: credential)
        let expectedURL = try XCTUnwrap(URL(string: "\(baseURL)\(credential.authenticationToken)"))

        XCTAssertEqual(expectedURL, authenticatedRequest.url)
    }

}
