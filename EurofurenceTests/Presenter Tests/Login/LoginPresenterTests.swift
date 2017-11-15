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
    
    func loginModuleDidCancelLogin() {
        
    }
    
    func loginModuleDidLoginSuccessfully() {
        
    }
    
}

class LoginPresenterTests: XCTestCase {
    
    var loginSceneFactory: StubLoginSceneFactory!
    var scene: UIViewController!
    
    override func setUp() {
        super.setUp()
        
        loginSceneFactory = StubLoginSceneFactory()
        let moduleFactory = PhoneLoginModuleFactory(sceneFactory: loginSceneFactory)
        let delegate = CapturingLoginModuleDelegate()
        scene = moduleFactory.makeLoginModule(delegate)
    }
    
    func testTheSceneFromTheFactoryIsReturned() {
        XCTAssertEqual(scene, loginSceneFactory.stubScene)
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
    
}
