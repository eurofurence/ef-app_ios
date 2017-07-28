//
//  WhenLoggingOut.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggingOut: XCTestCase {
    
    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenWithNilUserRegistrationToken() {
        let unexpectedToken = "JWT Token"
        let credential = LoginCredential(username: "", registrationNumber: 0, authenticationToken: unexpectedToken, tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        context.application.registerRemoteNotifications(deviceToken: Data())
        context.application.logout()
        
        XCTAssertNil(context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenThatWasPreviouslyRegistered() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let deviceToken = "Token time".data(using: .utf8)!
        context.application.registerRemoteNotifications(deviceToken: deviceToken)
        context.application.logout()
        
        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testFailureToUnregisterAuthTokenWithRemoteTokenRegistrationShouldIndicateLogoutFailure() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.application.add(logoutObserver: logoutObserver)
        context.registerRemoteNotifications()
        context.application.logout()
        context.capturingTokenRegistration.failLastRequest()
        
        XCTAssertTrue(logoutObserver.didFailToLogout)
    }
    
    func testFailureToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailureUntilActuallyLoggingOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.application.add(logoutObserver: logoutObserver)
        
        XCTAssertFalse(logoutObserver.didFailToLogout)
    }
    
    func testFailureToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailureUntilRegistrationActuallyGails() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.application.add(logoutObserver: logoutObserver)
        context.registerRemoteNotifications()
        context.application.logout()
        
        XCTAssertFalse(logoutObserver.didFailToLogout)
    }
    
    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailure() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.application.add(logoutObserver: logoutObserver)
        context.registerRemoteNotifications()
        context.application.logout()
        context.capturingTokenRegistration.succeedLastRequest()
        
        XCTAssertFalse(logoutObserver.didFailToLogout)
    }
    
    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldDeletePersistedLoginCredential() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.registerRemoteNotifications()
        context.application.logout()
        context.capturingTokenRegistration.succeedLastRequest()
        
        XCTAssertTrue(context.capturingLoginCredentialsStore.didDeletePersistedToken)
    }
    
    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotDeletePersistedLoginCredential() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.registerRemoteNotifications()
        context.application.logout()
        context.capturingTokenRegistration.failLastRequest()
        
        XCTAssertFalse(context.capturingLoginCredentialsStore.didDeletePersistedToken)
    }
    
}
