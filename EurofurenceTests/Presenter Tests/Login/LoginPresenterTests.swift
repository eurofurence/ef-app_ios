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
    
    var loginButtonWasDisabled = false
    func disableLoginButton() {
        loginButtonWasDisabled = true
    }
    
    private(set) var loginButtonWasEnabled = false
    func enableLoginButton() {
        loginButtonWasEnabled = true
    }
    
    func tapLoginButton() {
        delegate?.loginSceneDidTapLoginButton()
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

class CapturingLoginService: LoginService {
    
    private(set) var capturedRequest: LoginServiceRequest?
    func perform(_ request: LoginServiceRequest) {
        capturedRequest = request
    }
    
}

class LoginPresenterTests: XCTestCase {
    
    var loginSceneFactory: StubLoginSceneFactory!
    var loginService: CapturingLoginService!
    var scene: UIViewController!
    var delegate: CapturingLoginModuleDelegate!
    
    private func updateRegistrationNumber(_ registrationNumber: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber(registrationNumber)
    }
    
    private func updateUsername(_ username: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername(username)
    }
    
    private func updatePassword(_ password: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword(password)
    }
    
    override func setUp() {
        super.setUp()
        
        loginSceneFactory = StubLoginSceneFactory()
        loginService = CapturingLoginService()
        let moduleFactory = PhoneLoginModuleFactory(sceneFactory: loginSceneFactory, loginService: loginService)
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
        updateRegistrationNumber("1")
        updateUsername("User")
        updatePassword("Password")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithoutRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("")
        updateUsername("User")
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("?")
        updateUsername("User")
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidUsernameTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("1")
        updateUsername("")
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidPasswordTheLoginButtonShouldNotBeEnabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        updatePassword("")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasEnabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidPasswordTheLoginButtonShouldBeDisabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updatePassword("")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithPasswordEnteredLastTheLoginButtonNotBeDisabled() {
        updateRegistrationNumber("1")
        updateUsername("User")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updatePassword("Password")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldBeDisabled() {
        updateUsername("User")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateRegistrationNumber("?")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithRegistrationNumberEnteredLastTheLoginButtonShouldNotBeDisabled() {
        updateUsername("User")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateRegistrationNumber("42")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithInvalidUsernameTheLoginButtonShouldBeDisabled() {
        updateRegistrationNumber("1")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateUsername("")
        
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testWhenSceneSuppliesAllDetailsWithUsernameEnteredLastTheLoginButtonShouldNotBeDisabled() {
        updateRegistrationNumber("1")
        updatePassword("Password")
        loginSceneFactory.stubScene.loginButtonWasDisabled = false
        updateUsername("User")
        
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testTappingLoginButtonTellsLoginServiceToPerformLoginWithEnteredValues() {
        let regNo = 1
        let username = "User"
        let password = "Password"
        updateRegistrationNumber("\(regNo)")
        updateUsername(username)
        updatePassword(password)
        loginSceneFactory.stubScene.tapLoginButton()
        let expected = LoginServiceRequest(registrationNumber: regNo, username: username, password: password)
        
        XCTAssertEqual(expected, loginService.capturedRequest)
    }
    
}
