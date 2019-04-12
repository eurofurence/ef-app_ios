import EurofurenceModel
import XCTest

class WhenLoginStateChanges: XCTestCase {

    private func makeCredential(username: String = "",
                                registrationNumber: Int = 0,
                                authenticationToken: String = "",
                                tokenExpiryDate: Date = Date()) -> Credential {
        return Credential(username: username,
                               registrationNumber: registrationNumber,
                               authenticationToken: authenticationToken,
                               tokenExpiryDate: tokenExpiryDate)
    }

    func testLoggingInShouldReregisterTheSamePushDeviceToken() {
        let context = EurofurenceSessionTestBuilder().build()
        let deviceToken = "Token".data(using: .utf8)!
        context.registerForRemoteNotifications(deviceToken)

        XCTAssertEqual(deviceToken, context.notificationTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

    func testLoggingInWhenWeHaveTokenStoredShouldUseTheTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let existingCredential = makeCredential(authenticationToken: authenticationToken, tokenExpiryDate: .distantFuture)
        let context = EurofurenceSessionTestBuilder().with(existingCredential).build()
        context.registerForRemoteNotifications()

        XCTAssertEqual(authenticationToken, context.notificationTokenRegistration.capturedUserAuthenticationToken)
    }

    func testLoggingInWhenWeHaveTokenThatHasExpiredShouldNotUseTheTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let existingCredential = makeCredential(authenticationToken: authenticationToken, tokenExpiryDate: .distantPast)
        let context = EurofurenceSessionTestBuilder().with(existingCredential).build()
        context.registerForRemoteNotifications()

        XCTAssertNil(context.notificationTokenRegistration.capturedUserAuthenticationToken)
    }

    func testThePersistedTokenIsNotDeletedUntilTheUserActuallyLogsOut() {
        let context = EurofurenceSessionTestBuilder().build()
        XCTAssertFalse(context.credentialStore.didDeletePersistedToken)
    }

}
