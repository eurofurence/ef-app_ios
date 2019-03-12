//
//  WhenLoggingOutUnsuccessfully.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 08/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

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
        XCTAssertTrue(observer.logoutDidFail)
    }

    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotDeletePersistedCredential() {
        context.authenticationService.logout { _ in }
        context.notificationTokenRegistration.failLastRequest()

        XCTAssertFalse(context.credentialStore.didDeletePersistedToken)
        XCTAssertFalse(observer.loggedOut)
        XCTAssertTrue(observer.logoutDidFail)
    }

    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotNotifyLogoutObserversUserLoggedOut() {
        let logoutObserver = CapturingLogoutObserver()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.notificationTokenRegistration.failLastRequest()

        XCTAssertFalse(logoutObserver.didLogout)
        XCTAssertFalse(observer.loggedOut)
        XCTAssertTrue(observer.logoutDidFail)
    }

}
