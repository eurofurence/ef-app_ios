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

    let credential = Credential(username: "", registrationNumber: 0, authenticationToken: "Token", tokenExpiryDate: .distantFuture)
    var context: ApplicationTestBuilder.Context!
    var observer: CapturingAuthenticationStateObserver!

    override func setUp() {
        super.setUp()

        observer = CapturingAuthenticationStateObserver()
        context = ApplicationTestBuilder().with(credential).build()
        context.authenticationService.add(observer)
    }

    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenWithNilUserRegistrationToken() {
        context.application.services.notifications.storeRemoteNotificationsToken(Data())
        context.authenticationService.logout { _ in }

        XCTAssertNil(context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }

    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenThatWasPreviouslyRegistered() {
        let deviceToken = "Token time".data(using: .utf8)!
        context.application.services.notifications.storeRemoteNotificationsToken(deviceToken)
        context.authenticationService.logout { _ in }

        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailure() {
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertFalse(logoutObserver.didFailToLogout)
        XCTAssertFalse(observer.logoutDidFail)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldDeletePersistedCredential() {
        context.registerForRemoteNotifications()
        context.authenticationService.logout { _ in }
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertTrue(context.capturingCredentialStore.didDeletePersistedToken)
    }

    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotifyLogoutObserversUserLoggedOut() {
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertTrue(logoutObserver.didLogout)
        XCTAssertFalse(observer.logoutDidFail)
    }

}
