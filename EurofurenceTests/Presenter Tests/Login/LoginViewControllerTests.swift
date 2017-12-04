//
//  LoginViewControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingLoginSceneDelegate: LoginSceneDelegate {
    
    private(set) var cancelButtonTapped = false
    func loginSceneDidTapCancelButton() {
        cancelButtonTapped = true
    }
    
    private(set) var loginButtonTapped = false
    func loginSceneDidTapLoginButton() {
        loginButtonTapped = true
    }
    
    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String) {
        
    }
    
    func loginSceneDidUpdateUsername(_ username: String) {
        
    }
    
    func loginSceneDidUpdatePassword(_ password: String) {
        
    }
    
}

class LoginViewControllerTests: XCTestCase {
    
    var loginViewController: LoginViewControllerV2!
    var delegate: CapturingLoginSceneDelegate!
    
    override func setUp() {
        super.setUp()
        
        loginViewController = LoginViewControllerV2Factory().makeLoginScene() as! LoginViewControllerV2
        delegate = CapturingLoginSceneDelegate()
        loginViewController.delegate = delegate
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
    
    func testTappingLoginButtonTellsDelegate() {
        loginViewController.loginButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.loginButtonTapped)
    }
    
    func testDelegateNotToldLoginButtonTappedTooEarly() {
        XCTAssertFalse(delegate.loginButtonTapped)
    }
    
    func testTappingCancelButtonTellsDelegate() {
        loginViewController.cancelButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.cancelButtonTapped)
    }
    
    func testDelegateNotToldCancelButtonTappedTooEarly() {
        XCTAssertFalse(delegate.cancelButtonTapped)
    }
    
}
