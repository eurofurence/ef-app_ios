import EurofurenceModel
import XCTest

class DefaultCollectThemAllRequestFactoryShould: XCTestCase {

    func testProduceExpectedAnonymousRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let anonymousRequest = factory.makeAnonymousGameURLRequest()
        let expectedURL = URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token=empty").unsafelyUnwrapped

        XCTAssertEqual(expectedURL, anonymousRequest.url)
    }

    func testProduceExpectedAuthenticatedRequest() {
        let factory = DefaultCollectThemAllRequestFactory()
        let credential = Credential.randomValidCredential
        let authenticatedRequest = factory.makeAuthenticatedGameURLRequest(credential: credential)
        let expectedURLString = "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token=\(credential.authenticationToken)"
        let expectedURL = URL(string: expectedURLString).unsafelyUnwrapped

        XCTAssertEqual(expectedURL, authenticatedRequest.url)
    }

}
