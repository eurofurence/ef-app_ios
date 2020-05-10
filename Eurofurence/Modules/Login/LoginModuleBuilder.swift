import EurofurenceModel

class LoginModuleBuilder {

    private let authenticationService: AuthenticationService
    private let alertRouter: AlertRouter
    private var sceneFactory: LoginSceneFactory

    init(authenticationService: AuthenticationService, alertRouter: AlertRouter) {
        self.authenticationService = authenticationService
        self.alertRouter = alertRouter
        
        sceneFactory = LoginViewControllerFactory()
    }

    func with(_ sceneFactory: LoginSceneFactory) -> LoginModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> LoginModuleProviding {
        return LoginModule(sceneFactory: sceneFactory,
                           authenticationService: authenticationService,
                           alertRouter: alertRouter)
    }

}
