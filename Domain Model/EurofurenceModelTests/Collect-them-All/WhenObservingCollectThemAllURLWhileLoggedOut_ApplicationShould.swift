import EurofurenceModel
import XCTest

class WhenObservingCollectThemAllURLWhileLoggedOut_ApplicationShould: XCTestCase {

    func testEmitAnonymousGameURL() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let context = EurofurenceSessionTestBuilder().with(collectThemAllRequestFactory).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.collectThemAllService.subscribe(observer)

        XCTAssertEqual(collectThemAllRequestFactory.anonymousGameURLRequest, observer.capturedURLRequest)
    }

    func testEmitAuthenticatedGameURLForUserWhenLoggingIn() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let context = EurofurenceSessionTestBuilder().with(collectThemAllRequestFactory).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.collectThemAllService.subscribe(observer)
        let args = LoginArguments(registrationNumber: .random, username: .random, password: .random)
        context.authenticationService.login(args) { (_) in }
        let response = LoginResponse(userIdentifier: .random, username: .random, token: .random, tokenValidUntil: .random)
        context.api.simulateLoginResponse(response)
        let expectedCredential = Credential(username: response.username,
                                            registrationNumber: args.registrationNumber,
                                            authenticationToken: response.token,
                                            tokenExpiryDate: response.tokenValidUntil)
        let expected = collectThemAllRequestFactory.makeAuthenticatedGameURLRequest(credential: expectedCredential)

        XCTAssertEqual(expected, observer.capturedURLRequest)
    }

}
