//
//  EurofurenceLoginInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class EurofurenceLoginInteractorTests: XCTestCase {
    
    var interactor: EurofurenceLoginInteractor!
    var app: CapturingEurofurenceApplication!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        interactor = EurofurenceLoginInteractor(app: app)
    }
    
    func testAttemptingLoginAdaptsArguments() {
        let registrationNumber = Int(arc4random())
        let username = "User \(registrationNumber)"
        let password = "Password \(registrationNumber)"
        let input = LoginServiceRequest(registrationNumber: registrationNumber,
                                        username: username,
                                        password: password)
        let expected = LoginArguments(registrationNumber: registrationNumber,
                                      username: username,
                                      password: password)
        interactor.perform(input, completionHandler: { _ in })
        
        XCTAssertEqual(expected, app.capturedLoginArguments)
    }
    
    func testSuccessfulLoginsNotifyHandler() {
        let input = LoginServiceRequest(registrationNumber: 0,
                                        username: "",
                                        password: "")
        var didLogin = false
        interactor.perform(input, completionHandler: { didLogin = $0 == .success })
        let user = User(registrationNumber: 0, username: "")
        app.capturedLoginHandler?(.success(user))
        
        XCTAssertTrue(didLogin)
    }
    
    func testFailedLoginsNotifyHandler() {
        let input = LoginServiceRequest(registrationNumber: 0,
                                        username: "",
                                        password: "")
        var didFailToLogin = false
        interactor.perform(input, completionHandler: { didFailToLogin = $0 == .failure })
        app.capturedLoginHandler?(.failure)
        
        XCTAssertTrue(didFailToLogin)
    }
    
}
