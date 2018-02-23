//
//  EurofurenceAuthServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingAuthStateHandler {
    
    private(set) var capturedState: AuthState?
    func handle(_ state: AuthState) {
        capturedState = state
    }
    
}

class CapturingAuthenticationStateObserver: AuthenticationStateObserver {
    
    private(set) var capturedLoggedInUser: User?
    func userDidLogin(_ user: User) {
        capturedLoggedInUser = user
    }
    
    func userDidLogout() {
        
    }
    
}

class EurofurenceAuthServiceTests: XCTestCase {
    
    var app: CapturingEurofurenceApplication!
    var service: ApplicationAuthenticationService!
    var observer: CapturingAuthenticationStateObserver!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        service = ApplicationAuthenticationService(app: app)
        observer = CapturingAuthenticationStateObserver()
        service.add(observer: observer)
    }
    
    // MARK: Auth State
    
    func testDeterminingAuthStateRequestsUserFromApplication() {
        service.determineAuthState { _ in }
        XCTAssertTrue(app.wasRequestedForCurrentUser)
    }
    
    func testWhenNilUserReturnedTheAuthStateIsResolvedAsLoggedOut() {
        let handler = CapturingAuthStateHandler()
        service.determineAuthState(completionHandler: handler.handle)
        app.resolveUserRetrievalWithUser(nil)
        
        XCTAssertEqual(.loggedOut, handler.capturedState)
    }
    
    func testWhenNonNilUserReturnedTheAuthStateIsNotResolvedAsLoggedOut() {
        let handler = CapturingAuthStateHandler()
        service.determineAuthState(completionHandler: handler.handle)
        app.resolveUserRetrievalWithUser(User(registrationNumber: 42, username: ""))
        
        XCTAssertNotEqual(.loggedOut, handler.capturedState)
    }
    
    func testWhenNonNilUserReturnedTheAuthStateIsResolvedAsLoggedIn() {
        let handler = CapturingAuthStateHandler()
        service.determineAuthState(completionHandler: handler.handle)
        let user = User(registrationNumber: 42, username: "")
        app.resolveUserRetrievalWithUser(user)
        
        XCTAssertEqual(.loggedIn(user), handler.capturedState)
    }
    
    // MARK: Login
    
    func testAttemptingLoginAdaptsArguments() {
        let registrationNumber = Int.random
        let username = "User \(registrationNumber)"
        let password = "Password \(registrationNumber)"
        let input = LoginServiceRequest(registrationNumber: registrationNumber,
                                        username: username,
                                        password: password)
        let expected = LoginArguments(registrationNumber: registrationNumber,
                                      username: username,
                                      password: password)
        service.perform(input, completionHandler: { _ in })
        
        XCTAssertEqual(expected, app.capturedLoginArguments)
    }
    
    func testSuccessfulLoginsNotifyHandler() {
        let input = LoginServiceRequest(registrationNumber: 0,
                                        username: "",
                                        password: "")
        var didLogin = false
        service.perform(input, completionHandler: { didLogin = $0 == .success })
        let user = User(registrationNumber: 0, username: "")
        app.capturedLoginHandler?(.success(user))
        
        XCTAssertTrue(didLogin)
    }
    
    func testFailedLoginsNotifyHandler() {
        let input = LoginServiceRequest(registrationNumber: 0,
                                        username: "",
                                        password: "")
        var didFailToLogin = false
        service.perform(input, completionHandler: { didFailToLogin = $0 == .failure })
        app.capturedLoginHandler?(.failure)
        
        XCTAssertTrue(didFailToLogin)
    }
    
    func testObserversAreToldLoginSucceeded() {
        let input = LoginServiceRequest(registrationNumber: 0,
                                        username: "",
                                        password: "")
        service.perform(input) { (_) in }
        let user = User(registrationNumber: .random, username: "")
        app.capturedLoginHandler?(.success(user))
        
        XCTAssertEqual(observer.capturedLoggedInUser, user)
    }
    
}
