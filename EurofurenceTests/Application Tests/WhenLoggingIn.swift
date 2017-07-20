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
    
    private func makeLoginResponse(uid: Int = 0,
                                   username: String = "",
                                   token: String = "",
                                   tokenValidUntil: Date = Date()) -> APILoginResponse {
        return StubLoginResponse(uid: uid, username: username, token: token, tokenValidUntil: tokenValidUntil)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedUsername() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        
        XCTAssertEqual(expectedUsername, loginAPI.capturedLoginArguments?.username)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedRegNo() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedRegNo = 42
        context.login(registrationNumber: expectedRegNo)
        
        XCTAssertEqual(expectedRegNo, loginAPI.capturedLoginArguments?.regNo)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedPassword() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedPassword = "Some awesome password"
        context.login(password: expectedPassword)
        
        XCTAssertEqual(expectedPassword, loginAPI.capturedLoginArguments?.password)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUsername() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        loginAPI.simulateResponse(makeLoginResponse(username: expectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingLoginCredentialsStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUserID() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedUserID = 42
        context.login(registrationNumber: expectedUserID)
        loginAPI.simulateResponse(makeLoginResponse(uid: expectedUserID))
        
        XCTAssertEqual(expectedUserID, context.capturingLoginCredentialsStore.capturedCredential?.registrationNumber)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithLoginToken() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedToken = "JWT Token"
        context.login()
        loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingLoginCredentialsStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithTokenExpiry() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedTokenExpiry = Date.distantFuture
        context.login()
        loginAPI.simulateResponse(makeLoginResponse(tokenValidUntil: expectedTokenExpiry))
        
        XCTAssertEqual(expectedTokenExpiry, context.capturingLoginCredentialsStore.capturedCredential?.tokenExpiryDate)
    }
    
    func testLoggingInSuccessfulyShouldNotifyObserversAboutIt() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginSucceeded)
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.capturingLoginCredentialsStore.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(userAuthenticationObserver.notifiedLoginSucceeded)
        }
        
        context.application.add(userAuthenticationObserver)
        context.login()
        loginAPI.simulateResponse(makeLoginResponse())
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotifyObserverLoginSuccessful() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginSucceeded)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotRequestTheLoginEndpoint() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        
        XCTAssertNil(context.jsonPoster.postedURL)
    }
    
    func testLoggingInSuccessfullyThenRegisteringPushTokenShouldProvideAuthTokenWithPushRegistration() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedToken = "JWT Token"
        context.login()
        loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        context.application.registerRemoteNotifications(deviceToken: Data())
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let expectedToken = "JWT Token"
        context.application.registerRemoteNotifications(deviceToken: Data())
        context.login()
        loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testRemovingTheObserverThenLoggingInShouldNotTellTheObserverAboutIt() {
        let loginAPI = CapturingLoginAPI()
        let context = ApplicationTestBuilder().with(loginAPI).build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        context.application.remove(userAuthenticationObserver)
        loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(userAuthenticationObserver.notifiedLoginSucceeded)
    }
    
}
