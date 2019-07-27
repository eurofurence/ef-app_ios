import EurofurenceModel
import XCTest

class WhenLoggingOut_WithoutRegisteredDeviceToken: XCTestCase {

    func testWithoutHavingRegisteredForNotificationsThenTheUserShouldStillBeLoggedOut() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)

        XCTAssertTrue(context.notificationTokenRegistration.didRegisterNilPushTokenAndAuthToken)
    }

    func testLoggingInAsAnotherUserShouldRequestLoginUsingTheirDetails() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        context.authenticationService.logout { _ in }
        context.notificationTokenRegistration.succeedLastRequest()
        let secondUser = "Some other awesome guy"
        context.login(username: secondUser)

        XCTAssertEqual(secondUser, context.api.capturedLoginRequest?.username)
    }

}
