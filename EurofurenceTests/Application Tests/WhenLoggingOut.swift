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
        context.application.registerForRemoteNotifications(deviceToken: Data())
        context.application.logout() { _ in }
        
        XCTAssertNil(context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testTheRemoteNotificationsTokenRegistrationShouldReRegisterTheDeviceTokenThatWasPreviouslyRegistered() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let deviceToken = "Token time".data(using: .utf8)!
        context.application.registerForRemoteNotifications(deviceToken: deviceToken)
        context.application.logout() { _ in }
        
        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testFailureToUnregisterAuthTokenWithRemoteTokenRegistrationShouldIndicateLogoutFailure() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.failLastRequest()
        
        XCTAssertTrue(logoutObserver.didFailToLogout)
    }
    
    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotIndicateLogoutFailure() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.succeedLastRequest()
        
        XCTAssertFalse(logoutObserver.didFailToLogout)
    }
    
    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldDeletePersistedLoginCredential() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.registerForRemoteNotifications()
        context.application.logout() { _ in }
        context.capturingTokenRegistration.succeedLastRequest()
        
        XCTAssertTrue(context.capturingLoginCredentialsStore.didDeletePersistedToken)
    }
    
    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotDeletePersistedLoginCredential() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.registerForRemoteNotifications()
        context.application.logout() { _ in }
        context.capturingTokenRegistration.failLastRequest()
        
        XCTAssertFalse(context.capturingLoginCredentialsStore.didDeletePersistedToken)
    }
    
    func testSucceedingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotifyLogoutObserversUserLoggedOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.succeedLastRequest()
        
        XCTAssertTrue(logoutObserver.didLogout)
    }
    
    func testFailingToUnregisterAuthTokenWithRemoteTokenRegistrationShouldNotNotifyLogoutObserversUserLoggedOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.registerForRemoteNotifications()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        context.capturingTokenRegistration.failLastRequest()
        
        XCTAssertFalse(logoutObserver.didLogout)
    }
    
    func testWithoutHavingRegisteredForNotificationsThenTheUserShouldStillBeLoggedOut() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let logoutObserver = CapturingLogoutObserver()
        context.application.logout(completionHandler: logoutObserver.completionHandler)
        
        XCTAssertTrue(context.capturingTokenRegistration.didRegisterNilPushTokenAndAuthToken)
    }
    
    func testAddingAuthenticationStateObserverOnceLoggedOutShouldNotTellItTheUserIsLoggedIn() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.application.logout() { _ in }
        context.capturingTokenRegistration.succeedLastRequest()
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver: observer)
        
        XCTAssertFalse(observer.didLogIn)
    }
    
    func testLoggingInAsAnotherUserShouldRequestLoginUsingTheirDetails() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        context.application.logout() { _ in }
        context.capturingTokenRegistration.succeedLastRequest()
        let secondUser = "Some other awesome guy"
        context.login(username: secondUser)
        
        XCTAssertEqual(secondUser, context.loginAPI.capturedLoginRequest?.username)
    }
    
}
