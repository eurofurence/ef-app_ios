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
    
    var loginViewController: LoginViewControllerV2!
    
    override func setUp() {
        super.setUp()
        
        loginViewController = LoginViewControllerV2Factory().makeLoginScene() as! LoginViewControllerV2
    }
    
    func testLoginButtonIsDisabledByDefault() {
        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }
    
    func testEnablingTheLoginButton() {
        loginViewController.enableLoginButton()
        XCTAssertTrue(loginViewController.loginButton.isEnabled)
    }
    
    func testDisablingTheLoginButton() {
        loginViewController.enableLoginButton()
        loginViewController.disableLoginButton()
        
        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }
    
}
