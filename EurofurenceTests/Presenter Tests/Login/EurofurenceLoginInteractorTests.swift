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
        let app = CapturingEurofurenceApplication()
        let interactor = EurofurenceLoginInteractor(app: app)
        interactor.perform(input, completionHandler: { _ in })
        
        XCTAssertEqual(expected, app.capturedLoginArguments)
    }
    
}
