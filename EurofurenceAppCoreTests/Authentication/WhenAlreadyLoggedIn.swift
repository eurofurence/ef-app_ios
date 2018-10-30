//
//  WhenAlreadyLoggedIn.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 30/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenAlreadyLoggedIn: XCTestCase {

    func testBeingLoggedInThenLoggingInShouldNotifyObserverLoginSuccessful() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)

        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }

    func testBeingLoggedInThenLoggingInShouldNotRequestTheAPIToLogin() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)

        XCTAssertNil(context.loginAPI.capturedLoginRequest)
    }

}
