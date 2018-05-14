//
//  EurofurenceAuthServiceTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

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
    
    // MARK: Login
    
    func testAttemptingLoginAdaptsArguments() {
        let registrationNumber = Int.random
        let username = "User \(registrationNumber)"
        let password = "Password \(registrationNumber)"
        let input = LoginArguments(registrationNumber: registrationNumber,
                                   username: username,
                                   password: password)
        let expected = LoginArguments(registrationNumber: registrationNumber,
                                      username: username,
                                      password: password)
        service.perform(input, completionHandler: { _ in })
        
        XCTAssertEqual(expected, app.capturedLoginArguments)
    }
    
    func testSuccessfulLoginsNotifyHandler() {
        let input = LoginArguments(registrationNumber: 0,
                                   username: "",
                                   password: "")
        var didLogin = false
        service.perform(input, completionHandler: { didLogin = $0 == .success })
        let user = User(registrationNumber: 0, username: "")
        app.capturedLoginHandler?(.success(user))
        
        XCTAssertTrue(didLogin)
    }
    
    func testFailedLoginsNotifyHandler() {
        let input = LoginArguments(registrationNumber: 0,
                                   username: "",
                                   password: "")
        var didFailToLogin = false
        service.perform(input, completionHandler: { didFailToLogin = $0 == .failure })
        app.capturedLoginHandler?(.failure)
        
        XCTAssertTrue(didFailToLogin)
    }
    
    func testObserversAreToldLoginSucceeded() {
        let input = LoginArguments(registrationNumber: 0,
                                   username: "",
                                   password: "")
        service.perform(input) { (_) in }
        let user = User(registrationNumber: .random, username: "")
        app.capturedLoginHandler?(.success(user))
        
        XCTAssertEqual(observer.capturedLoggedInUser, user)
    }
    
}
