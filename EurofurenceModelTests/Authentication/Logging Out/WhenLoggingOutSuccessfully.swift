import EurofurenceModel
import XCTest

class WhenLoggingOutSuccessfully: XCTestCase {

    let credential = Credential(username: "", registrationNumber: 0, authenticationToken: "Token", tokenExpiryDate: .distantFuture)
    var context: EurofurenceSessionTestBuilder.Context!
    var observer: CapturingAuthenticationStateObserver!

    override func setUp() {
        super.setUp()

        observer = CapturingAuthenticationStateObserver()
        context = EurofurenceSessionTestBuilder().with(credential).build()
        context.authenticationService.add(observer)
    }

    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenWithNilUserRegistrationToken() {
        context.session.services.notifications.storeRemoteNotificationsToken(Data())
        context.authenticationService.logout { _ in }

        XCTAssertNil(context.notificationTokenRegistration.capturedUserAuthenticationToken)
    }

    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenThatWasPreviouslyRegistered() {
        let deviceToken = unwrap("Token time".data(using: .utf8))
        context.session.services.notifications.storeRemoteNotificationsToken(deviceToken)
        context.authenticationService.logout { _ in }

        XCTAssertEqual(deviceToken, context.notificationTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailure() {
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.notificationTokenRegistration.succeedLastRequest()

        XCTAssertFalse(logoutObserver.didFailToLogout)
        XCTAssertFalse(observer.logoutDidFail)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldDeletePersistedCredential() {
        context.registerForRemoteNotifications()
        context.authenticationService.logout { _ in }
        context.notificationTokenRegistration.succeedLastRequest()

        XCTAssertTrue(context.credentialStore.didDeletePersistedToken)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotifyLogoutObserversUserLoggedOut() {
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.notificationTokenRegistration.succeedLastRequest()

        XCTAssertTrue(logoutObserver.didLogout)
        XCTAssertFalse(observer.logoutDidFail)
    }

}
