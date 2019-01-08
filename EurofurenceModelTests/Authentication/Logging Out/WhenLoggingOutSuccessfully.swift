//
//  WhenLoggingOutSuccessfully.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLoggingOutSuccessfully: XCTestCase {

    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenWithNilUserRegistrationToken() {
        let unexpectedToken = "JWT Token"
        let credential = Credential(username: "", registrationNumber: 0, authenticationToken: unexpectedToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        context.application.services.notifications.storeRemoteNotificationsToken(Data())
        context.application.logout { _ in }

        XCTAssertNil(context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }

    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenThatWasPreviouslyRegistered() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let deviceToken = "Token time".data(using: .utf8)!
        context.application.services.notifications.storeRemoteNotificationsToken(deviceToken)
        context.application.logout { _ in }

        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailure() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertFalse(logoutObserver.didFailToLogout)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldDeletePersistedCredential() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.registerForRemoteNotifications()
        context.application.logout { _ in }
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertTrue(context.capturingCredentialStore.didDeletePersistedToken)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotifyLogoutObserversUserLoggedOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertTrue(logoutObserver.didLogout)
    }

}
