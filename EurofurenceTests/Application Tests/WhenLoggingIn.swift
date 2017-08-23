//
//  WhenLoggingIn.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggingIn: XCTestCase {
    
    private func makeLoginResponse(uid: String = "",
                                   username: String = "",
                                   token: String = "",
                                   tokenValidUntil: Date = Date()) -> APILoginResponse {
        return StubLoginResponse(uid: uid, username: username, token: token, tokenValidUntil: tokenValidUntil)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        
        XCTAssertEqual(expectedUsername, context.loginAPI.capturedLoginRequest?.username)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedRegNo() {
        let context = ApplicationTestBuilder().build()
        let expectedRegNo = 42
        context.login(registrationNumber: expectedRegNo)
        
        XCTAssertEqual(expectedRegNo, context.loginAPI.capturedLoginRequest?.regNo)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedPassword() {
        let context = ApplicationTestBuilder().build()
        let expectedPassword = "Some awesome password"
        context.login(password: expectedPassword)
        
        XCTAssertEqual(expectedPassword, context.loginAPI.capturedLoginRequest?.password)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: expectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingLoginCredentialsStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUsernameProvidedByLoginCallAndNotLoginResponse() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        let unexpectedUsername = "Some other guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: unexpectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingLoginCredentialsStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUserIDFromLoginRequest() {
        let context = ApplicationTestBuilder().build()
        let expectedUserID = 42
        context.login(registrationNumber: expectedUserID)
        context.loginAPI.simulateResponse(makeLoginResponse(uid: "Something else"))
        
        XCTAssertEqual(expectedUserID, context.capturingLoginCredentialsStore.capturedCredential?.registrationNumber)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithLoginToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingLoginCredentialsStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithTokenExpiry() {
        let context = ApplicationTestBuilder().build()
        let expectedTokenExpiry = Date.distantFuture
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(tokenValidUntil: expectedTokenExpiry))
        
        XCTAssertEqual(expectedTokenExpiry, context.capturingLoginCredentialsStore.capturedCredential?.tokenExpiryDate)
    }
    
    func testLoggingInSuccessfulyShouldNotifyObserversAboutIt() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.capturingLoginCredentialsStore.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
        }
        
        context.login(completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(loginObserver.notifiedLoginFailed)
    }
    
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
    
    func testLoggingInSuccessfullyThenRegisteringPushTokenShouldProvideAuthTokenWithPushRegistration() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        context.application.registerForRemoteNotifications(deviceToken: Data())
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.application.registerForRemoteNotifications(deviceToken: Data())
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldProvideExpectedLoginToHandler() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        let username = "Some cool guy"
        let regNo = 42
        let expectedUser = User(registrationNumber: regNo, username: username)
        context.login(registrationNumber: regNo, username: username, completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertEqual(expectedUser, loginObserver.loggedInUser)
    }
    
}
