//
//  LoginPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubLoginSceneFactory: LoginSceneFactory {
    
    let stubScene = CapturingLoginScene()
    func makeLoginScene() -> UIViewController & LoginScene {
        return stubScene
    }
    
}

class CapturingLoginScene: UIViewController, LoginScene {
    
    var delegate: LoginSceneDelegate?
    
    private(set) var loginButtonWasDisabled = false
    func disableLoginButton() {
        loginButtonWasDisabled = true
    }
    
    private(set) var loginButtonWasEnabled = false
    func enableLoginButton() {
        loginButtonWasEnabled = true
    }
    
}

class CapturingLoginModuleDelegate: LoginModuleDelegate {
    
    private(set) var loginCancelled = false
    func loginModuleDidCancelLogin() {
        loginCancelled = true
    }
    
    func loginModuleDidLoginSuccessfully() {
        
    }
    
}

class LoginPresenterTests: XCTestCase {
    
    var loginSceneFactory: StubLoginSceneFactory!
    var scene: UIViewController!
    var delegate: CapturingLoginModuleDelegate!
    
    override func setUp() {
        super.setUp()
        
        loginSceneFactory = StubLoginSceneFactory()
        let moduleFactory = PhoneLoginModuleFactory(sceneFactory: loginSceneFactory)
        delegate = CapturingLoginModuleDelegate()
        scene = moduleFactory.makeLoginModule(delegate)
    }
    
    func testTheSceneFromTheFactoryIsReturned() {
        XCTAssertEqual(scene, loginSceneFactory.stubScene)
    }
    
    func testTappingTheCancelButtonTellsDelegateLoginCancelled() {
        loginSceneFactory.stubScene.delegate?.loginSceneDidTapCancelButton()
        XCTAssertTrue(delegate.loginCancelled)
    }
    
    func testTheDelegateIsNotToldLoginCancelledUntilUserTapsButton() {
        XCTAssertFalse(delegate.loginCancelled)
    }
    
    func testTheLoginButtonIsDisabled() {
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsTheLoginButtonIsEnabled() {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber("1")
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername("User")
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword("Password")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithoutRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber("")
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername("User")
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber("?")
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername("User")
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
}
