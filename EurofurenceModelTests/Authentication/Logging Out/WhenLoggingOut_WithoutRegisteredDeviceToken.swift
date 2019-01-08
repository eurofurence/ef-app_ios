//
//  WhenLoggingOut_WithoutRegisteredDeviceToken.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 08/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenLoggingOut_WithoutRegisteredDeviceToken: XCTestCase {

    func testWithoutHavingRegisteredForNotificationsThenTheUserShouldStillBeLoggedOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.application.logout(completionHandler: logoutObserver.completionHandler)

        XCTAssertTrue(context.capturingTokenRegistration.didRegisterNilPushTokenAndAuthToken)
    }

    func testLoggingInAsAnotherUserShouldRequestLoginUsingTheirDetails() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.application.logout { _ in }
        context.capturingTokenRegistration.succeedLastRequest()
        let secondUser = "Some other awesome guy"
        context.login(username: secondUser)

        XCTAssertEqual(secondUser, context.loginAPI.capturedLoginRequest?.username)
    }

}
