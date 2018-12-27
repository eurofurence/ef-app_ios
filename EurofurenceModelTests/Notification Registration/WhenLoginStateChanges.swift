//
//  WhenLoginStateChanges.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

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
        let context = ApplicationTestBuilder().build()
        let deviceToken = "Token".data(using: .utf8)!
        context.registerForRemoteNotifications(deviceToken)

        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

    func testLoggingInWhenWeHaveTokenStoredShouldUseTheTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let existingCredential = makeCredential(authenticationToken: authenticationToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(existingCredential).build()
        context.registerForRemoteNotifications()

        XCTAssertEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }

    func testLoggingInWhenWeHaveTokenThatHasExpiredShouldNotUseTheTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let existingCredential = makeCredential(authenticationToken: authenticationToken, tokenExpiryDate: .distantPast)
        let context = ApplicationTestBuilder().with(existingCredential).build()
        context.registerForRemoteNotifications()

        XCTAssertNil(context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }

    func testThePersistedTokenIsNotDeletedUntilTheUserActuallyLogsOut() {
        let context = ApplicationTestBuilder().build()
        XCTAssertFalse(context.capturingCredentialStore.didDeletePersistedToken)
    }

}
