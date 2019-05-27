import EurofurenceModel

class LoginModuleBuilder {

    private var sceneFactory: LoginSceneFactory
    private let authenticationService: AuthenticationService
    private var alertRouter: AlertRouter

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        sceneFactory = LoginViewControllerFactory()
        alertRouter = WindowAlertRouter.shared
    }

    func with(_ sceneFactory: LoginSceneFactory) -> LoginModuleBuilder {
        self.sceneFactory = sceneFactory
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
