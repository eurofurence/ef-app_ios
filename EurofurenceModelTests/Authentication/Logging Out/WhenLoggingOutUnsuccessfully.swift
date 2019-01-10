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

    func testFailureToUnregisterAuthTokenWithRemoteTokenRegistrationShouldIndicateLogoutFailure() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.failLastRequest()

        XCTAssertTrue(logoutObserver.didFailToLogout)
    }

    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotDeletePersistedCredential() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.registerForRemoteNotifications()
        context.authenticationService.logout { _ in }
        context.capturingTokenRegistration.failLastRequest()

        XCTAssertFalse(context.capturingCredentialStore.didDeletePersistedToken)
    }

    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotNotifyLogoutObserversUserLoggedOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.authenticationService.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.failLastRequest()

        XCTAssertFalse(logoutObserver.didLogout)
    }

}
