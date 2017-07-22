//
//  V2LoginAPITests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingV2LoginObserver {
    
    private(set) var capturedLoginResponse: APILoginResponse?
    private(set) var notifiedLoginFailed = false
    func observe(_ result: APIResponse<APILoginResponse>) {
        switch result {
        case .success(let response):
            capturedLoginResponse = response
        case .failure:
            notifiedLoginFailed = true
        }
    }
    
}

class V2LoginAPITests: XCTestCase {
    
    var api: V2LoginAPI!
    var jsonPoster: CapturingJSONPoster!
    
    override func setUp() {
        super.setUp()
        
        jsonPoster = CapturingJSONPoster()
        api = V2LoginAPI(jsonPoster: jsonPoster)
    }
    
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
    
    private func makeObserverForVerifyingLoginResponse(missingKey: String) -> CapturingV2LoginObserver {
        var payload = makeSuccessfulLoginPayload()
        payload.removeValue(forKey: missingKey)
        return makeObserverForVerifyingLoginResponse(payload)
    }
    
    private func makeObserverForVerifyingLoginResponse(_ payload: [String : String]) -> CapturingV2LoginObserver {
        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
        return makeObserverForVerifyingLoginResponse(data)
    }
    
    private func makeObserverForVerifyingLoginResponse(_ data: Data?) -> CapturingV2LoginObserver {
        let loginResponseObserver = CapturingV2LoginObserver()
        performLogin(makeLoginParameters(), completionHandler: loginResponseObserver.observe)
        jsonPoster.invokeLastCompletionHandler(responseData: data)
        
        return loginResponseObserver
    }
    
    private func makeLoginParameters(regNo: Int = 0,
                                     username: String = "Username",
                                     password: String = "Password") -> APILoginParameters {
        return APILoginParameters(regNo: regNo, username: username, password: password)
    }
    
    private func performLogin(_ parameters: APILoginParameters, completionHandler: @escaping LoginResponseHandler = { _ in }) {
        api.performLogin(arguments: parameters, completionHandler: completionHandler)
    }
    
    func testTheLoginEndpointShouldReceievePOSTRequest() {
        performLogin(makeLoginParameters())
        XCTAssertEqual("https://app.eurofurence.org/api/v2/Tokens/RegSys", jsonPoster.postedURL)
    }
    
    func testTheLoginEndpointShouldNotReceievePOSTRequestUntilCallingLogin() {
        XCTAssertNil(jsonPoster.postedURL)
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithRegNo() {
        let registrationNumber = 42
        performLogin(makeLoginParameters(regNo: registrationNumber))
        
        XCTAssertEqual(registrationNumber, jsonPoster.postedJSONValue(forKey: "RegNo"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithUsername() {
        let username = "Some awesome guy"
        performLogin(makeLoginParameters(username: username))
        
        XCTAssertEqual(username, jsonPoster.postedJSONValue(forKey: "Username"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithPassword() {
        let password = "It's a secret"
        performLogin(makeLoginParameters(password: password))
        
        XCTAssertEqual(password, jsonPoster.postedJSONValue(forKey: "Password"))
    }
    
    func testLoginResponseReturnsNilDataShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(nil)
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseReturnsInvalidJSONShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse("Not json!".data(using: .utf8))
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseReturnsWrongRootJSONTypeShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse("[]".data(using: .utf8))
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingUsernameFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "Username")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingUserIDFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "Uid")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingTokenFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "Token")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseMissingTokenExpiryFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "TokenValidUntil")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoginResponseContainingTokenExpiryAsSomethingOtherThanExpectedDateShouldTellTheObserverLoginFailed() {
        let payload = makeSuccessfulLoginPayload(validUntil: "Some weird format")
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(payload)
        
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }
    
    func testLoggingInSuccessfullyShouldReturnResponseWithUsername() {
        let username = "User"
        let data = makeSuccessfulLoginData(username: username)
        let observer = makeObserverForVerifyingLoginResponse(data)
        
        XCTAssertEqual(username, observer.capturedLoginResponse?.username)
    }
    
    func testLoggingInSuccessfullyShouldReturnResponseWithAuthToken() {
        let authToken = "Auth Token"
        let data = makeSuccessfulLoginData(authToken: authToken)
        let observer = makeObserverForVerifyingLoginResponse(data)
        
        XCTAssertEqual(authToken, observer.capturedLoginResponse?.token)
    }
    
    func testLoggingInSuccessfullyShouldReturnResponseWithUserID() {
        let uid = "RegSys:23:99999"
        let data = makeSuccessfulLoginData(userID: uid)
        let observer = makeObserverForVerifyingLoginResponse(data)
        
        XCTAssertEqual(uid, observer.capturedLoginResponse?.uid)
    }
    
    func testLoggingInSuccessfullyShouldReturnResponseWithAuthTokenExpiry() {
        let data = makeSuccessfulLoginData(validUntil: "2017-07-17T19:45:22.666Z")
        let observer = makeObserverForVerifyingLoginResponse(data)
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 17, hour: 19, minute: 45, second: 22)
        let receievedDate = observer.capturedLoginResponse?.tokenValidUntil
        var actualComponents: DateComponents?
        let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
        if let receievedDate = receievedDate {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }
        
        XCTAssertEqual(expectedComponents, actualComponents)
    }
    
}
