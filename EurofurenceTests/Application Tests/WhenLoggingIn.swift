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
    
    // TODO: Delete below functions when behaviour for tests no longer requires them
    
    private func makeSuccessfulLoginPayload(username: String = "",
                                            userID: String = "0",
                                            authToken: String = "",
                                            validUntil: String = "2017-07-17T19:45:22.666Z") -> [String : String] {
        return ["Username" : username,
                "Uid": userID,
                "Token" : authToken,
                "TokenValidUntil": validUntil]
    }
    
    private func makeSuccessfulLoginData(username: String = "",
                                         userID: String = "0",
                                         authToken: String = "",
                                         validUntil: String = "2017-07-17T19:45:22.666Z") -> Data {
        let payload = makeSuccessfulLoginPayload(username: username, userID: userID, authToken: authToken, validUntil: validUntil)
        return try! JSONSerialization.data(withJSONObject: payload, options: [])
    }
    
    private func makeObserverForVerifyingLoginFailure(missingKey: String) -> CapturingUserAuthenticationObserver {
        var payload = makeSuccessfulLoginPayload()
        payload.removeValue(forKey: missingKey)
        return makeObserverForVerifyingLoginFailure(payload)
    }
    
    private func makeObserverForVerifyingLoginFailure(_ payload: [String : String]) -> CapturingUserAuthenticationObserver {
        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
        return makeObserverForVerifyingLoginFailure(data)
    }
    
    private func makeObserverForVerifyingLoginFailure(_ data: Data?) -> CapturingUserAuthenticationObserver {
        let context = ApplicationTestBuilder().build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        context.simulateJSONResponse(data)
        
        return userAuthenticationObserver
    }
    
    // TODO: - Rework below to use API abstraction
    
    func testTheLoginEndpointShouldReceievePOSTRequest() {
        let context = ApplicationTestBuilder().build()
        context.login()
        
        XCTAssertEqual("https://app.eurofurence.org/api/v2/Tokens/RegSys", context.jsonPoster.postedURL)
    }
    
    func testTheLoginEndpointShouldNotReceievePOSTRequestUntilCallingLogin() {
        let context = ApplicationTestBuilder().build()
        XCTAssertNil(context.jsonPoster.postedURL)
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithRegNo() {
        let context = ApplicationTestBuilder().build()
        let registrationNumber = 42
        context.login(registrationNumber: registrationNumber)
        
        XCTAssertEqual(registrationNumber, context.jsonPoster.postedJSONValue(forKey: "RegNo"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithUsername() {
        let context = ApplicationTestBuilder().build()
        let username = "Some awesome guy"
        context.login(username: username)
        
        XCTAssertEqual(username, context.jsonPoster.postedJSONValue(forKey: "Username"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithPassword() {
        let context = ApplicationTestBuilder().build()
        let password = "It's a secret"
        context.login(password: password)
        
        XCTAssertEqual(password, context.jsonPoster.postedJSONValue(forKey: "Password"))
    }
    
    func testLoginResponseReturnsNilDataShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(nil)
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseReturnsInvalidJSONShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure("Not json!".data(using: .utf8))
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseReturnsWrongRootJSONTypeShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure("[]".data(using: .utf8))
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingUsernameFieldShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(missingKey: "Username")
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingUserIDFieldShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(missingKey: "Uid")
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseContainingUserIDAsSomethingOtherThanIntegerShouldTellTheObserverLoginFailed() {
        let payload = makeSuccessfulLoginPayload(userID: "Not an int!")
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(payload)
        
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingTokenFieldShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(missingKey: "Token")
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingTokenExpiryFieldShouldTellTheObserverLoginFailed() {
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(missingKey: "TokenValidUntil")
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseContainingTokenExpiryAsSomethingOtherThanExpectedDateShouldTellTheObserverLoginFailed() {
        let payload = makeSuccessfulLoginPayload(validUntil: "Some weird format")
        let userAuthenticationObserver = makeObserverForVerifyingLoginFailure(payload)
        
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginFailed)
    }
    
    // TODO: - Rework above tests to use API abstraction
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        context.simulateJSONResponse(makeSuccessfulLoginData(username: expectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingLoginCredentialsStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUserID() {
        let context = ApplicationTestBuilder().build()
        let expectedUserID = 42
        context.login(username: String(expectedUserID))
        context.simulateJSONResponse(makeSuccessfulLoginData(userID: String(expectedUserID)))
        
        XCTAssertEqual(expectedUserID, context.capturingLoginCredentialsStore.capturedCredential?.registrationNumber)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData(authToken: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingLoginCredentialsStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginTokenExpiry() {
        let context = ApplicationTestBuilder().build()
        let expectedTokenExpiry = "2017-07-17T19:45:22.666Z"
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData(validUntil: expectedTokenExpiry))
        
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 17, hour: 19, minute: 45, second: 22)
        let receievedDate = context.capturingLoginCredentialsStore.capturedCredential?.tokenExpiryDate
        var actualComponents: DateComponents?
        let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
        if let receievedDate = receievedDate {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
    func testLoggingInSuccessfulyShouldNotifyObserversAboutIt() {
        let context = ApplicationTestBuilder().build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData())
        
        XCTAssertTrue(userAuthenticationObserver.notifiedLoginSucceeded)
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let context = ApplicationTestBuilder().build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.capturingLoginCredentialsStore.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(userAuthenticationObserver.notifiedLoginSucceeded)
        }
        
        context.application.add(userAuthenticationObserver)
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData())
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let context = ApplicationTestBuilder().build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData())
        
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
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData(authToken: expectedToken))
        context.application.registerRemoteNotifications(deviceToken: Data())
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.application.registerRemoteNotifications(deviceToken: Data())
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData(authToken: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testRemovingTheObserverThenLoggingInShouldNotTellTheObserverAboutIt() {
        let context = ApplicationTestBuilder().build()
        let userAuthenticationObserver = CapturingUserAuthenticationObserver()
        context.application.add(userAuthenticationObserver)
        context.login()
        context.application.remove(userAuthenticationObserver)
        context.simulateJSONResponse(makeSuccessfulLoginData())
        
        XCTAssertFalse(userAuthenticationObserver.notifiedLoginSucceeded)
    }
    
}
