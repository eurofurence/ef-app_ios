//
//  WhenLoginStateChanges.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoginStateChanges: XCTestCase {
    
    private func makeCredential(username: String = "",
                                registrationNumber: Int = 0,
                                authenticationToken: String = "",
                                tokenExpiryDate: Date = Date()) -> LoginCredential {
        return LoginCredential(username: username,
                               registrationNumber: registrationNumber,
                               authenticationToken: authenticationToken,
                               tokenExpiryDate: tokenExpiryDate)
    }
    
    func testLoggingInShouldReregisterPushDeviceTokenAfterOneWasRegistered() {
        let context = ApplicationTestBuilder().build()
        context.registerRemoteNotifications()
        context.notifyUserLoggedIn()
        
        XCTAssertEqual(2, context.capturingTokenRegistration.numberOfRegistrations)
    }
    
    func testLoggingInShouldReregisterTheSamePushDeviceToken() {
        let context = ApplicationTestBuilder().build()
        let deviceToken = "Token".data(using: .utf8)!
        context.registerRemoteNotifications(deviceToken)
        context.notifyUserLoggedIn()
        
        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testLoggingInShouldReregisterTheUserAuthenticationToken() {
        let context = ApplicationTestBuilder().build()
        context.registerRemoteNotifications()
        let authenticationToken = "JWT Token"
        context.notifyUserLoggedIn(authenticationToken)
        
        XCTAssertEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testBeingLoggedInOnLaunchShouldRegisterTheExistingTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let context = ApplicationTestBuilder().build()
        context.notifyUserLoggedIn(authenticationToken)
        let deviceToken = Data()
        context.registerRemoteNotifications(deviceToken)
        
        XCTAssertEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testBeingLoggedInOnLaunchShouldNotRegisterTheExistingTokenWhenTheTokenExpired() {
        let authenticationToken = "JWT Token"
        let expirationDate = Date()
        let simulatedDate = expirationDate.addingTimeInterval(1)
        let context = ApplicationTestBuilder().with(simulatedDate).build()
        context.notifyUserLoggedIn(authenticationToken, expires: expirationDate)
        context.registerRemoteNotifications()
        
        XCTAssertNotEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInShouldStoreTheCredential() {
        let authenticationToken = "JWT Token"
        let context = ApplicationTestBuilder().build()
        context.notifyUserLoggedIn(authenticationToken)
        
        XCTAssertEqual(authenticationToken, context.capturingLoginCredentialsStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInShouldNotStoreTheTokenIfItHasExpired() {
        let authenticationToken = "JWT Token"
        let context = ApplicationTestBuilder().build()
        context.notifyUserLoggedIn(authenticationToken, expires: .distantPast)
        
        XCTAssertNil(context.capturingLoginCredentialsStore.capturedCredential)
    }
    
    func testLoggingInWhenWeHaveTokenStoredShouldUseTheTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let existingCredential = makeCredential(authenticationToken: authenticationToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(existingCredential).build()
        context.registerRemoteNotifications()
        
        XCTAssertEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInWhenWeHaveTokenThatHasExpiredShouldNotUseTheTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let existingCredential = makeCredential(authenticationToken: authenticationToken, tokenExpiryDate: .distantPast)
        let context = ApplicationTestBuilder().with(existingCredential).build()
        context.registerRemoteNotifications()
        
        XCTAssertNil(context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testWhenTheUserLogsOutThePersistedCredentialIsDeleted() {
        let context = ApplicationTestBuilder().build()
        context.notifyUserLoggedOut()
        
        XCTAssertTrue(context.capturingLoginCredentialsStore.didDeletePersistedToken)
    }
    
    func testThePersistedTokenIsNotDeletedUntilTheUserActuallyLogsOut() {
        let context = ApplicationTestBuilder().build()
        XCTAssertFalse(context.capturingLoginCredentialsStore.didDeletePersistedToken)
    }
    
}
