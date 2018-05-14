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
                                   tokenValidUntil: Date = Date()) -> LoginResponse {
        return LoginResponse(userIdentifier: uid, username: username, token: token, tokenValidUntil: tokenValidUntil)
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
    
    func testLoggingInSuccessfullyShouldPersistCredentialWithUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: expectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingCredentialStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistCredentialWithUsernameProvidedByLoginCallAndNotLoginResponse() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        let unexpectedUsername = "Some other guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: unexpectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingCredentialStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistCredentialWithUserIDFromLoginRequest() {
        let context = ApplicationTestBuilder().build()
        let expectedUserID = 42
        context.login(registrationNumber: expectedUserID)
        context.loginAPI.simulateResponse(makeLoginResponse(uid: "Something else"))
        
        XCTAssertEqual(expectedUserID, context.capturingCredentialStore.capturedCredential?.registrationNumber)
    }
    
    func testLoggingInSuccessfullyShouldPersistCredentialWithLoginToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingCredentialStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldPersistCredentialWithTokenExpiry() {
        let context = ApplicationTestBuilder().build()
        let expectedTokenExpiry = Date.distantFuture
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(tokenValidUntil: expectedTokenExpiry))
        
        XCTAssertEqual(expectedTokenExpiry, context.capturingCredentialStore.capturedCredential?.tokenExpiryDate)
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
        context.capturingCredentialStore.blockToRunBeforeCompletingCredentialStorage = {
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
        context.application.storeRemoteNotificationsToken(Data())
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.application.storeRemoteNotificationsToken(Data())
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
    
    func testSuccessfulLoginTellsObserversTheUserHasLoggedIn() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertEqual(user, observer.capturedLoggedInUser)
    }
    
    func testAddingObserverAfterSuccessfullyLoggingInTellsItAboutTheLoggedInUser() {
        let context = ApplicationTestBuilder().build()
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)
        
        XCTAssertEqual(user, observer.capturedLoggedInUser)
    }
    
}
