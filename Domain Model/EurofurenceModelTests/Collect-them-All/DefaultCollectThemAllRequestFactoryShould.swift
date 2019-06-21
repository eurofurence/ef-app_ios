import EurofurenceModel
import XCTest

class DefaultCollectThemAllRequestFactoryShould: XCTestCase {

    func testProduceExpectedAnonymousRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let anonymousRequest = factory.makeAnonymousGameURLRequest()
        let expectedURL = unwrap(URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect"))

        XCTAssertEqual(expectedURL, anonymousRequest.url)
    }

    func testProduceExpectedAuthenticatedRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let credential = Credential.randomValidCredential
        let authenticatedRequest = factory.makeAuthenticatedGameURLRequest(credential: credential)
        let expectedURL = unwrap(URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token=\(credential.authenticationToken)"))

        XCTAssertEqual(expectedURL, authenticatedRequest.url)
    }

}
