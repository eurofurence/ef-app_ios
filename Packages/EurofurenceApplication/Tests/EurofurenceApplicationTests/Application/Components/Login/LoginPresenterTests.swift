import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class LoginPresenterTests: XCTestCase {

    var context: LoginPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = LoginPresenterTestBuilder().build()
    }

    func testTheSceneFromTheFactoryIsReturned() {
        XCTAssertEqual(context.scene, context.loginSceneFactory.stubScene)
    }

    func testTheSceneIsToldToDisplayTheLoginTitle() {
        XCTAssertEqual(.login, context.loginSceneFactory.stubScene.capturedTitle)
    }

    func testTappingTheCancelButtonTellsDelegateLoginCancelled() {
        context.loginSceneFactory.stubScene.delegate?.loginSceneDidTapCancelButton()
        XCTAssertTrue(context.delegate.loginCancelled)
    }

    func testTheDelegateIsNotToldLoginCancelledUntilUserTapsButton() {
        XCTAssertFalse(context.delegate.loginCancelled)
    }

    func testTheLoginButtonIsDisabled() {
        context.loginSceneFactory.stubScene.delegate?.loginSceneWillAppear()
        XCTAssertTrue(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testTheLoginButtonIsNotDisabledUntilTheSceneWillAppear() {
        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testWhenSceneSuppliesAllDetailsTheLoginButtonIsEnabled() {
        context.updateRegistrationNumber("1")
        context.updateUsername("User")
        context.updatePassword("Password")

        XCTAssertTrue(context.loginSceneFactory.stubScene.loginButtonWasEnabled)
    }

    func testWhenSceneSuppliesAllDetailsWithoutRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        context.updateRegistrationNumber("")
        context.updateUsername("User")
        context.updatePassword("Password")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasEnabled)
    }

    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldNotBeEnabled() {
        context.updateRegistrationNumber("?")
        context.updateUsername("User")
        context.updatePassword("Password")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasEnabled)
    }

    func testWhenSceneSuppliesAllDetailsWithInvalidUsernameTheLoginButtonShouldNotBeEnabled() {
        context.updateRegistrationNumber("1")
        context.updateUsername("")
        context.updatePassword("Password")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasEnabled)
    }

    func testWhenSceneSuppliesAllDetailsWithInvalidPasswordTheLoginButtonShouldNotBeEnabled() {
        context.updateRegistrationNumber("1")
        context.updateUsername("User")
        context.updatePassword("")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasEnabled)
    }

    func testWhenSceneSuppliesAllDetailsWithInvalidPasswordTheLoginButtonShouldBeDisabled() {
        context.updateRegistrationNumber("1")
        context.updateUsername("User")
        context.loginSceneFactory.stubScene.loginButtonWasDisabled = false
        context.updatePassword("")

        XCTAssertTrue(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testWhenSceneSuppliesAllDetailsWithPasswordEnteredLastTheLoginButtonNotBeDisabled() {
        context.updateRegistrationNumber("1")
        context.updateUsername("User")
        context.loginSceneFactory.stubScene.loginButtonWasDisabled = false
        context.updatePassword("Password")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testWhenSceneSuppliesAllDetailsWithInvalidRegistrationNumberTheLoginButtonShouldBeDisabled() {
        context.updateUsername("User")
        context.updatePassword("Password")
        context.loginSceneFactory.stubScene.loginButtonWasDisabled = false
        context.updateRegistrationNumber("?")

        XCTAssertTrue(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testWhenSceneSuppliesAllDetailsWithRegistrationNumberEnteredLastTheLoginButtonShouldNotBeDisabled() {
        context.updateUsername("User")
        context.updatePassword("Password")
        context.loginSceneFactory.stubScene.loginButtonWasDisabled = false
        context.updateRegistrationNumber("42")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testWhenSceneSuppliesAllDetailsWithInvalidUsernameTheLoginButtonShouldBeDisabled() {
        context.updateRegistrationNumber("1")
        context.updatePassword("Password")
        context.loginSceneFactory.stubScene.loginButtonWasDisabled = false
        context.updateUsername("")

        XCTAssertTrue(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testWhenSceneSuppliesAllDetailsWithUsernameEnteredLastTheLoginButtonShouldNotBeDisabled() {
        context.updateRegistrationNumber("1")
        context.updatePassword("Password")
        context.loginSceneFactory.stubScene.loginButtonWasDisabled = false
        context.updateUsername("User")

        XCTAssertFalse(context.loginSceneFactory.stubScene.loginButtonWasDisabled)
    }

    func testTappingLoginButtonTellsLoginServiceToPerformLoginWithEnteredValues() {
        let regNo = 1
        let username = "User"
        let password = "Password"
        context.updateRegistrationNumber("\(regNo)")
        context.updateUsername(username)
        context.updatePassword(password)
        context.loginSceneFactory.stubScene.tapLoginButton()
        context.completeAlertPresentation()

        let actual: LoginArguments? = context.authenticationService.capturedRequest

        XCTAssertEqual(regNo, actual?.registrationNumber)
        XCTAssertEqual(username, actual?.username)
        XCTAssertEqual(password, actual?.password)
    }

    func testAlertWithLoggingInTitleDisplayedWhenLoginServiceBeginsLoginProcedure() {
        context.inputValidCredentials()
        context.tapLoginButton()

        XCTAssertEqual(.loggingIn, context.alertRouter.presentedAlertTitle)
    }

    func testTappingLoginButtonWaitsForAlertPresentationToFinishBeforeAskingServiceToLogin() {
        context.alertRouter.automaticallyPresentAlerts = false
        context.inputValidCredentials()
        context.tapLoginButton()

        XCTAssertNil(context.authenticationService.capturedRequest)
    }

    func testAlertWithLogginInDescriptionDisplayedWhenLoginServiceBeginsLoginProcedure() {
        context.inputValidCredentials()
        context.tapLoginButton()

        XCTAssertEqual(.loggingInDetail, context.alertRouter.presentedAlertMessage)
    }

    func testLoginServiceSucceedsWithLoginTellsAlertToDismiss() {
        context.inputValidCredentials()
        context.tapLoginButton()
        let alert = context.alertRouter.lastAlert
        context.simulateLoginSuccess()

        XCTAssertEqual(true, alert?.dismissed)
    }

    func testAlertNotDismissedBeforeServiceReturns() {
        context.inputValidCredentials()
        context.tapLoginButton()

        XCTAssertEqual(false, context.alertRouter.lastAlert?.dismissed)
    }

    func testLoginServiceFailsToLoginShowsAlertWithLoginErrorTitle() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginFailure()
        context.dismissLastAlert()

        XCTAssertEqual(.loginError, context.alertRouter.presentedAlertTitle)
    }

    func testLoginSucceedsDoesNotShowLoginFailedAlert() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginSuccess()
        context.dismissLastAlert()

        XCTAssertNotEqual(.loginError, context.alertRouter.presentedAlertTitle)
    }

    func testLoginErrorAlertIsNotShownUntilPreviousAlertIsDismissed() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginFailure()

        XCTAssertNotEqual(.loginError, context.alertRouter.presentedAlertTitle)
    }

    func testLoginServiceFailsToLoginShowsAlertWithLoginErrorDetail() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginFailure()
        context.dismissLastAlert()

        XCTAssertEqual(.loginErrorDetail, context.alertRouter.presentedAlertMessage)
    }

    func testLoginServiceFailsToLoginShowsAlertWithOKAction() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginFailure()
        context.dismissLastAlert()

        XCTAssertNotNil(context.alertRouter.capturedAction(title: .ok))
    }

    func testLoginServiceSucceedsTellsDelegateLoginSucceeded() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginSuccess()
        context.dismissLastAlert()

        XCTAssertTrue(context.delegate.loginFinishedSuccessfully)
    }

    func testLoginServiceFailsDoesNotTellDelegateLoginSucceeded() {
        context.inputValidCredentials()
        context.tapLoginButton()
        context.simulateLoginFailure()
        context.dismissLastAlert()

        XCTAssertFalse(context.delegate.loginFinishedSuccessfully)
    }

}
