import EurofurenceModel

class LoginModuleBuilder {

    private var sceneFactory: LoginSceneFactory
    private var authenticationService: AuthenticationService
    private var alertRouter: AlertRouter

    init() {
        sceneFactory = LoginViewControllerFactory()
        authenticationService = ApplicationStack.instance.services.authentication
        alertRouter = WindowAlertRouter.shared
    }

    func with(_ sceneFactory: LoginSceneFactory) -> LoginModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ authenticationService: AuthenticationService) -> LoginModuleBuilder {
        self.authenticationService = authenticationService
        return self
    }

    func with(_ alertRouter: AlertRouter) -> LoginModuleBuilder {
        self.alertRouter = alertRouter
        return self
    }

    func build() -> LoginModuleProviding {
        return LoginModule(sceneFactory: sceneFactory,
                           authenticationService: authenticationService,
                           alertRouter: alertRouter)
    }

}
