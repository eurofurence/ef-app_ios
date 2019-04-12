import EurofurenceModel
import XCTest

class WhenObservingCollectThemAllURLWhileLoggedIn_ApplicationShould: XCTestCase {

    func testEmitAuthenticatedGameURLForUser() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let credential = Credential(username: .random,
                                    registrationNumber: .random,
                                    authenticationToken: .random,
                                    tokenExpiryDate: .random)
        let context = EurofurenceSessionTestBuilder().with(collectThemAllRequestFactory).with(credential).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.collectThemAllService.subscribe(observer)
        let expected = collectThemAllRequestFactory.makeAuthenticatedGameURLRequest(credential: credential)

        XCTAssertEqual(expected, observer.capturedURLRequest)
    }

    func testUpdateTheObserversWithTheAnonymousRequestWhenLoggingOut() {
        let collectThemAllRequestFactory = StubCollectThemAllRequestFactory()
        let credential = Credential(username: .random,
                                    registrationNumber: .random,
                                    authenticationToken: .random,
                                    tokenExpiryDate: .random)
        let context = EurofurenceSessionTestBuilder().with(collectThemAllRequestFactory).with(credential).build()
        let observer = CapturingCollectThemAllURLObserver()
        context.collectThemAllService.subscribe(observer)
        context.authenticationService.logout { (_) in }
        context.notificationTokenRegistration.succeedLastRequest()

        XCTAssertEqual(collectThemAllRequestFactory.anonymousGameURLRequest, observer.capturedURLRequest)
    }

}
