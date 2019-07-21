@testable import Eurofurence
import UIKit

class LoginPresenterTestBuilder {
    
    struct Context {
        var loginSceneFactory: StubLoginSceneFactory
        var authenticationService: FakeAuthenticationService
        var scene: UIViewController
        var delegate: CapturingLoginModuleDelegate
        var alertRouter: CapturingAlertRouter
    }
    
    func build() -> Context {
        let loginSceneFactory = StubLoginSceneFactory()
        let authenticationService = FakeAuthenticationService(authState: .loggedOut)
        let alertRouter = CapturingAlertRouter()
        alertRouter.automaticallyPresentAlerts = true
        let delegate = CapturingLoginModuleDelegate()
        let scene = LoginModuleBuilder(authenticationService: authenticationService)
            .with(loginSceneFactory)
            .with(alertRouter)
            .build()
            .makeLoginModule(delegate)
        
        return Context(loginSceneFactory: loginSceneFactory,
                       authenticationService: authenticationService,
                       scene: scene,
                       delegate: delegate,
                       alertRouter: alertRouter)
    }
    
}

extension LoginPresenterTestBuilder.Context {
    
    func inputValidCredentials() {
        updateRegistrationNumber("1")
        updateUsername("Username")
        updatePassword("Password")
    }
    
    func updateRegistrationNumber(_ registrationNumber: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateRegistrationNumber(registrationNumber)
    }
    
    func updateUsername(_ username: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdateUsername(username)
    }
    
    func updatePassword(_ password: String) {
        loginSceneFactory.stubScene.delegate?.loginSceneDidUpdatePassword(password)
    }
    
    func completeAlertPresentation() {
        alertRouter.completePendingPresentation()
    }
    
    func simulateLoginFailure() {
        authenticationService.failRequest()
    }
    
    func simulateLoginSuccess() {
        authenticationService.fulfillRequest()
    }
    
    func tapLoginButton() {
        loginSceneFactory.stubScene.tapLoginButton()
    }
    
    func dismissLastAlert() {
        alertRouter.lastAlert?.completeDismissal()
    }
    
}
