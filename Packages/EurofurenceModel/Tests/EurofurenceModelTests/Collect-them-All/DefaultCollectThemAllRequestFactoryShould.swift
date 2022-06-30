import EurofurenceModel
import XCTest

class DefaultCollectThemAllRequestFactoryShould: XCTestCase {

    func testProduceExpectedAnonymousRequest() throws {
        let conventionIdentifier = ConventionIdentifier(identifier: "CID")
        let factory = DefaultCollectThemAllRequestFactory(conventionIdentifier: conventionIdentifier)
        let anonymousRequest = factory.makeAnonymousGameURLRequest()
        let urlString = "https://app.eurofurence.org/CID/companion/#/login?embedded=true&returnPath=/collect&token="
        let expectedURL = try XCTUnwrap(URL(string: "\(urlString)empty"))

        XCTAssertEqual(expectedURL, anonymousRequest.url)
    }

    func testProduceExpectedAuthenticatedRequest() throws {
        let credential = Credential.randomValidCredential
        
        let conventionIdentifier = ConventionIdentifier(identifier: "CID")
        let factory = DefaultCollectThemAllRequestFactory(conventionIdentifier: conventionIdentifier)
        let authenticatedRequest = factory.makeAuthenticatedGameURLRequest(credential: credential)
        let urlString = "https://app.eurofurence.org/CID/companion/#/login?embedded=true&returnPath=/collect&token="
        let expectedURL = try XCTUnwrap(URL(string: "\(urlString)\(credential.authenticationToken)"))

        XCTAssertEqual(expectedURL, authenticatedRequest.url)
    }

}
