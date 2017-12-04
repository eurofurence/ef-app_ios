//
//  LoginViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class LoginViewControllerTests: XCTestCase {
    
    func testLoginButtonIsDisabledByDefault() {
        let loginViewController = LoginViewControllerV2Factory().makeLoginScene() as! LoginViewControllerV2
        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }
    
}
