//
//  LoginPresenterTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class LoginPresenterTests: XCTestCase {
    
    var loginSceneFactory: StubLoginSceneFactory!
    var authenticationService: CapturingAuthenticationService!
    var scene: UIViewController!
    var delegate: CapturingLoginModuleDelegate!
    var alertRouter: CapturingAlertRouter!
    
    override func setUp() {
        super.setUp()
        
        loginSceneFactory = StubLoginSceneFactory()
        authenticationService = CapturingAuthenticationService(authState: .loggedOut)
        alertRouter = CapturingAlertRouter()
        alertRouter.automaticallyPresentAlerts = true
        delegate = CapturingLoginModuleDelegate()
        scene = LoginModuleBuilder()
            .with(loginSceneFactory)
            .with(authenticationService)
            .with(alertRouter)
            .build()
            .makeLoginModule(delegate)
    }
    
    private func inputValidCredentials() {
        updateRegistrationNumber("1")
        updateUsername("Username")
        updatePassword("Password")
    }
    
    private func updateRegistrationNumber(_ registrationNumber: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber(registrationNumber)
    }
    
    private func updateUsername(_ username: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername(username)
    }
    
    private func updatePassword(_ password: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword(password)
    }
    
    private func completeAlertPresentation() {
        alertRouter.completePendingPresentation()
    }
    
    private func simulateLoginFailure() {
        authenticationService.failRequest()
    }
    
    private func simulateLoginSuccess() {
        authenticationService.fulfillRequest()
    }
    
    private func tapLoginButton() {
        loginSceneFactory.stubScene.tapLoginButton()
    }
    
    private func dismissLastAlert() {
        alertRouter.lastAlert?.completeDismissal()
    }
    
    func testTheSceneFromTheFactoryIsReturned() {
        XCTAssertEqual(scene, loginSceneFactory.stubScene)
    }
    
    func testTheSceneIsToldToDisplayTheLoginTitle() {
        XCTAssertEqual(.login, loginSceneFactory.stubScene.capturedTitle)
    }
    
    func testTappingTheCancelButtonTellsDelegateLoginCancelled() {
        loginSceneFactory.stubScene.delegate?.loginSceneDidTapCancelButton()
        XCTAssertTrue(delegate.loginCancelled)
    }
    
    func testTheDelegateIsNotToldLoginCancelledUntilUserTapsButton() {
        XCTAssertFalse(delegate.loginCancelled)
    }
    
    func testTheLoginButtonIsDisabled() {
        loginSceneFactory.stubScene.delegate?.loginSceneWillAppear()
        XCTAssertTrue(loginSceneFactory.stubScene.loginButtonWasDisabled)
    }
    
    func testTheLoginButtonIsNotDisabledUntilTheSceneWillAppear() {
        XCTAssertFalse(loginSceneFactory.stubScene.loginButtonWasDisabled)
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
        completeAlertPresentation()
        let expected = LoginServiceRequest(registrationNumber: regNo, username: username, password: password)
        
        XCTAssertEqual(expected, authenticationService.capturedRequest)
    }
    
    func testAlertWithLoggingInTitleDisplayedWhenLoginServiceBeginsLoginProcedure() {
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertEqual(.loggingIn, alertRouter.presentedAlertTitle)
    }
    
    func testTappingLoginButtonWaitsForAlertPresentationToFinishBeforeAskingServiceToLogin() {
        alertRouter.automaticallyPresentAlerts = false
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertNil(authenticationService.capturedRequest)
    }
    
    func testAlertWithLogginInDescriptionDisplayedWhenLoginServiceBeginsLoginProcedure() {
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertEqual(.loggingInDetail, alertRouter.presentedAlertMessage)
    }
    
    func testLoginServiceSucceedsWithLoginTellsAlertToDismiss() {
        inputValidCredentials()
        tapLoginButton()
        let alert = alertRouter.lastAlert
        simulateLoginSuccess()
        
        XCTAssertEqual(true, alert?.dismissed)
    }
    
    func testAlertNotDismissedBeforeServiceReturns() {
        inputValidCredentials()
        tapLoginButton()
        
        XCTAssertEqual(false, alertRouter.lastAlert?.dismissed)
    }
    
    func testLoginServiceFailsToLoginShowsAlertWithLoginErrorTitle() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertEqual(.loginError, alertRouter.presentedAlertTitle)
    }
    
    func testLoginSucceedsDoesNotShowLoginFailedAlert() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginSuccess()
        dismissLastAlert()
        
        XCTAssertNotEqual(.loginError, alertRouter.presentedAlertTitle)
    }
    
    func testLoginErrorAlertIsNotShownUntilPreviousAlertIsDismissed() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        
        XCTAssertNotEqual(.loginError, alertRouter.presentedAlertTitle)
    }
    
    func testLoginServiceFailsToLoginShowsAlertWithLoginErrorDetail() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertEqual(.loginErrorDetail, alertRouter.presentedAlertMessage)
    }
    
    func testLoginServiceFailsToLoginShowsAlertWithOKAction() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertNotNil(alertRouter.capturedAction(title: .ok))
    }
    
    func testLoginServiceSucceedsTellsDelegateLoginSucceeded() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginSuccess()
        dismissLastAlert()
        
        XCTAssertTrue(delegate.loginFinishedSuccessfully)
    }
    
    func testLoginServiceFailsDoesNotTellDelegateLoginSucceeded() {
        inputValidCredentials()
        tapLoginButton()
        simulateLoginFailure()
        dismissLastAlert()
        
        XCTAssertFalse(delegate.loginFinishedSuccessfully)
    }
    
}
