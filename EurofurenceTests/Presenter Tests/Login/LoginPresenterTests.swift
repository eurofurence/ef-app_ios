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
    
    private(set) var loginButtonWasDisabled = false
    func disableLoginButton() {
        loginButtonWasDisabled = true
    }
    
}

class CapturingLoginModuleDelegate: LoginModuleDelegate {
    
    func loginModuleDidCancelLogin() {
        
    }
    
    func loginModuleDidLoginSuccessfully() {
        
    }
    
}

class LoginPresenterTests: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturned() {
        let loginSceneFactory = StubLoginSceneFactory()
        let moduleFactory = PhoneLoginModuleFactory(sceneFactory: loginSceneFactory)
        let delegate = CapturingLoginModuleDelegate()
        let scene = moduleFactory.makeLoginModule(delegate)
        
        XCTAssertEqual(scene, loginSceneFactory.stubScene)
    }
    
    func testTheLoginButtonIsDisabled() {
        let loginSceneFactory = StubLoginSceneFactory()
        let moduleFactory = PhoneLoginModuleFactory(sceneFactory: loginSceneFactory)
        let delegate = CapturingLoginModuleDelegate()
        _ = moduleFactory.makeLoginModule(delegate)
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
}
