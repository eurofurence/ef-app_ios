import EurofurenceModel
import XCTest

class WhenLoggingOutUnsuccessfully: XCTestCase {

    var context: EurofurenceSessionTestBuilder.Context!
    var observer: CapturingAuthenticationStateObserver!

    override func setUp() {
        super.setUp()

        observer = CapturingAuthenticationStateObserver()
        context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        context.authenticationService.add(observer)
        context.registerForRemoteNotifications()
    }

    func testFailureToUnregisterAuthTokenWithRemoteTokenRegistrationShouldIndicateLogoutFailure() {
        let logoutObserver = CapturingLogoutObserver()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.notificationTokenRegistration.failLastRequest()

        XCTAssertTrue(logoutObserver.didFailToLogout)
    }

    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotDeletePersistedCredential() {
        context.authenticationService.logout { _ in }
        context.notificationTokenRegistration.failLastRequest()

        XCTAssertFalse(context.credentialRepository.didDeletePersistedToken)
        XCTAssertFalse(observer.loggedOut)
    }

    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotNotifyLogoutObserversUserLoggedOut() {
        let logoutObserver = CapturingLogoutObserver()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.notificationTokenRegistration.failLastRequest()

        XCTAssertFalse(logoutObserver.didLogout)
        XCTAssertFalse(observer.loggedOut)
    }

}
