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
        
        XCTAssertEqual(expectedUsername, context.loginAPI.capturedLoginArguments?.username)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedRegNo() {
        let context = ApplicationTestBuilder().build()
        let expectedRegNo = 42
        context.login(registrationNumber: expectedRegNo)
        
        XCTAssertEqual(expectedRegNo, context.loginAPI.capturedLoginArguments?.regNo)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedPassword() {
        let context = ApplicationTestBuilder().build()
        let expectedPassword = "Some awesome password"
        context.login(password: expectedPassword)
        
        XCTAssertEqual(expectedPassword, context.loginAPI.capturedLoginArguments?.password)
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
        context.application.add(loginObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.capturingLoginCredentialsStore.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
        }
        
        context.application.add(loginObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(loginObserver.notifiedLoginFailed)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotifyObserverLoginSuccessful() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        
        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotRequestTheAPIToLogin() {
        let context = ApplicationTestBuilder().loggedInWithValidCredential().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        
        XCTAssertNil(context.loginAPI.capturedLoginArguments)
    }
    
    func testLoggingInSuccessfullyThenRegisteringPushTokenShouldProvideAuthTokenWithPushRegistration() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        context.application.registerRemoteNotifications(deviceToken: Data())
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.application.registerRemoteNotifications(deviceToken: Data())
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testRemovingTheObserverThenLoggingInShouldNotTellTheObserverAboutIt() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.application.remove(loginObserver)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
    }
    
    func testAddingAuthenticationObserverAfterBeingLoggedInShouldTellItWeAreLoggedIn() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        context.application.add(authenticationStateObserver)
        
        XCTAssertTrue(authenticationStateObserver.didLogIn)
    }
    
    func testLoggingInShouldTellAuthenticationStateObserversWeAreLoggedIn() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertTrue(authenticationStateObserver.didLogIn)
    }
    
    func testLoggingInShouldNotTellAuthenticationStateObserversWeAreLoggedInUntilLoginSucceeds() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        context.login()
        
        XCTAssertFalse(authenticationStateObserver.didLogIn)
    }
    
    func testLoggingInShouldTellAuthenticationStateObserversWeLoggedInWithUsersName() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        let username = "Some cool guy"
        context.login(username: username)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertEqual(username, authenticationStateObserver.loggedInUser?.username)
    }
    
    func testLoggingInShouldTellAuthenticationStateObserversWeLoggedInWithUsersRegNo() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        let regNo = 42
        context.login(registrationNumber: regNo)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertEqual(regNo, authenticationStateObserver.loggedInUser?.registrationNumber)
    }
    
    func testAddingAuthenticationObserverAfterBeingLoggedInShouldTellItWhoWeAreLoggedInAs() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        let expectedUser = User(registrationNumber: 42, username: "Some cool guy")
        context.login(registrationNumber: expectedUser.registrationNumber, username: expectedUser.username)
        context.loginAPI.simulateResponse(makeLoginResponse())
        context.application.add(authenticationStateObserver)
        
        XCTAssertEqual(expectedUser, authenticationStateObserver.loggedInUser)
    }
    
    func testRemovingAuthenticationObserverBeforeLoggingInShouldNotTellItWeLoggedIn() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        context.application.remove(authenticationStateObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(authenticationStateObserver.didLogIn)
    }
    
    func testAddingAuthenticationStateObserverWhenLaunchingWithExistingCredentialShouldTellTheObserverTheUsernameWeAreLoggedInAs() {
        let expectedUsername = "Some cool guy"
        let credential = LoginCredential(username: expectedUsername,
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        
        XCTAssertEqual(expectedUsername, authenticationStateObserver.loggedInUser?.username)
    }
    
    func testAddingAuthenticationStateObserverWhenLaunchingWithExistingCredentialShouldTellTheObserverTheRegNoWeAreLoggedInAs() {
        let expectedRegNo = 42
        let credential = LoginCredential(username: "",
                                         registrationNumber: 42,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        
        XCTAssertEqual(expectedRegNo, authenticationStateObserver.loggedInUser?.registrationNumber)
    }
    
}
