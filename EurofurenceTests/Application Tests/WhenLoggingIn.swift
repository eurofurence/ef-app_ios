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
    
    private func makeObserverForVerifyingLoginFailure(missingKey: String) -> CapturingLoginObserver {
        var payload = makeSuccessfulLoginPayload()
        payload.removeValue(forKey: missingKey)
        return makeObserverForVerifyingLoginFailure(payload)
    }
    
    private func makeObserverForVerifyingLoginFailure(_ payload: [String : String]) -> CapturingLoginObserver {
        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
        return makeObserverForVerifyingLoginFailure(data)
    }
    
    private func makeObserverForVerifyingLoginFailure(_ data: Data?) -> CapturingLoginObserver {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.simulateJSONResponse(data)
        
        return loginObserver
    }
    
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
        let loginObserver = makeObserverForVerifyingLoginFailure(nil)
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseReturnsInvalidJSONShouldTellTheObserverLoginFailed() {
        let loginObserver = makeObserverForVerifyingLoginFailure("Not json!".data(using: .utf8))
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseReturnsWrongRootJSONTypeShouldTellTheObserverLoginFailed() {
        let loginObserver = makeObserverForVerifyingLoginFailure("[]".data(using: .utf8))
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingUsernameFieldShouldTellTheObserverLoginFailed() {
        let loginObserver = makeObserverForVerifyingLoginFailure(missingKey: "Username")
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingUserIDFieldShouldTellTheObserverLoginFailed() {
        let loginObserver = makeObserverForVerifyingLoginFailure(missingKey: "Uid")
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseContainingUserIDAsSomethingOtherThanIntegerShouldTellTheObserverLoginFailed() {
        let payload = makeSuccessfulLoginPayload(userID: "Not an int!")
        let loginObserver = makeObserverForVerifyingLoginFailure(payload)
        
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingTokenFieldShouldTellTheObserverLoginFailed() {
        let loginObserver = makeObserverForVerifyingLoginFailure(missingKey: "Token")
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingTokenExpiryFieldShouldTellTheObserverLoginFailed() {
        let loginObserver = makeObserverForVerifyingLoginFailure(missingKey: "TokenValidUntil")
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseContainingTokenExpiryAsSomethingOtherThanExpectedDateShouldTellTheObserverLoginFailed() {
        let payload = makeSuccessfulLoginPayload(validUntil: "Some weird format")
        let loginObserver = makeObserverForVerifyingLoginFailure(payload)
        
        XCTAssertTrue(loginObserver.notifiedLoginFailed)
    }
    
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
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData())
        
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
        context.simulateJSONResponse(makeSuccessfulLoginData())
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.simulateJSONResponse(makeSuccessfulLoginData())
        
        XCTAssertFalse(loginObserver.notifiedLoginFailed)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotifyObserverLoginSuccessful() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        
        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotRequestTheLoginEndpoint() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
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
    
}
