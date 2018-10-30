//
//  WhenLoggingIn.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenLoggingIn: XCTestCase {

    private func makeLoginResponse(uid: String = "",
                                   username: String = "",
                                   token: String = "",
                                   tokenValidUntil: Date = Date()) -> LoginResponse {
        return LoginResponse(userIdentifier: uid, username: username, token: token, tokenValidUntil: tokenValidUntil)
    }

    var context: ApplicationTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
    }

    func testUsesLoginArgumentsAgainstAPI() {
        let username = "Some awesome guy"
        let registrationNumber = 42
        let password = "Some awesome password"
        let arguments = LoginArguments(registrationNumber: registrationNumber,
                                       username: username,
                                       password: password)
        context.application.login(arguments) { (_) in }
        let capturedLoginRequest: LoginRequest? = context.loginAPI.capturedLoginRequest

        XCTAssertEqual(username, capturedLoginRequest?.username)
        XCTAssertEqual(registrationNumber, capturedLoginRequest?.regNo)
        XCTAssertEqual(password, capturedLoginRequest?.password)
    }

    func testLoggingInSuccessfullyShouldPersistCredentialWithUsername() {
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: expectedUsername))

        XCTAssertEqual(expectedUsername, context.capturingCredentialStore.capturedCredential?.username)
    }

    func testLoggingInSuccessfullyShouldPersistCredentialWithUsernameProvidedByLoginCallAndNotLoginResponse() {
        let expectedUsername = "Some awesome guy"
        let unexpectedUsername = "Some other guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: unexpectedUsername))

        XCTAssertEqual(expectedUsername, context.capturingCredentialStore.capturedCredential?.username)
    }

    func testLoggingInSuccessfullyShouldPersistCredentialWithUserIDFromLoginRequest() {
        let expectedUserID = 42
        context.login(registrationNumber: expectedUserID)
        context.loginAPI.simulateResponse(makeLoginResponse(uid: "Something else"))

        XCTAssertEqual(expectedUserID, context.capturingCredentialStore.capturedCredential?.registrationNumber)
    }

    func testLoggingInSuccessfullyShouldPersistCredentialWithLoginToken() {
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))

        XCTAssertEqual(expectedToken, context.capturingCredentialStore.capturedCredential?.authenticationToken)
    }

    func testLoggingInSuccessfullyShouldPersistCredentialWithTokenExpiry() {
        let expectedTokenExpiry = Date.distantFuture
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(tokenValidUntil: expectedTokenExpiry))

        XCTAssertEqual(expectedTokenExpiry, context.capturingCredentialStore.capturedCredential?.tokenExpiryDate)
    }

    func testLoggingInSuccessfulyShouldNotifyObserversAboutIt() {
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())

        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }

    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let loginObserver = CapturingLoginObserver()
        context.capturingCredentialStore.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
        }

        context.login(completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())
    }

    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let loginObserver = CapturingLoginObserver()
        context.login(completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())

        XCTAssertFalse(loginObserver.notifiedLoginFailed)
    }

    func testLoggingInSuccessfullyThenRegisteringPushTokenShouldProvideAuthTokenWithPushRegistration() {
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        context.application.storeRemoteNotificationsToken(Data())

        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }

    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let expectedToken = "JWT Token"
        context.application.storeRemoteNotificationsToken(Data())
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))

        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }

    func testLoggingInSuccessfullyShouldProvideExpectedLoginToHandler() {
        let loginObserver = CapturingLoginObserver()
        let username = "Some cool guy"
        let regNo = 42
        let expectedUser = User(registrationNumber: regNo, username: username)
        context.login(registrationNumber: regNo, username: username, completionHandler: loginObserver.completionHandler)
        context.loginAPI.simulateResponse(makeLoginResponse())

        XCTAssertEqual(expectedUser, loginObserver.loggedInUser)
    }

    func testSuccessfulLoginTellsObserversTheUserHasLoggedIn() {
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())

        XCTAssertEqual(user, observer.capturedLoggedInUser)
    }

    func testAddingObserverAfterSuccessfullyLoggingInTellsItAboutTheLoggedInUser() {
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)

        XCTAssertEqual(user, observer.capturedLoggedInUser)
    }

    func testLoggingOutTellsObserversTheUserHasLoggedOut() {
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())
        context.application.logout(completionHandler: { (_) in })
        context.capturingTokenRegistration.succeedLastRequest()

        XCTAssertTrue(observer.loggedOut)
    }

    func testObserverNotToldUserLoggedOutUntilLogoutSucceeds() {
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)
        observer.loggedOut = false
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())
        context.application.logout(completionHandler: { (_) in })

        XCTAssertFalse(observer.loggedOut)
    }

    func testObserverNotToldUserLoggedOutWhenLogoutFails() {
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)
        observer.loggedOut = false
        let user = User(registrationNumber: .random, username: .random)
        context.login(registrationNumber: user.registrationNumber, username: user.username, completionHandler: { (_) in })
        context.loginAPI.simulateResponse(makeLoginResponse())
        context.application.logout(completionHandler: { (_) in })
        context.capturingTokenRegistration.failLastRequest()

        XCTAssertFalse(observer.loggedOut)
    }

    func testAddingObserverWhenNotLoggedInTellsObserverUserLoggedOut() {
        let observer = CapturingAuthenticationStateObserver()
        context.application.add(observer)

        XCTAssertTrue(observer.loggedOut)
    }

}
