import EurofurenceModel

class LoginComponentBuilder {

    private let authenticationService: AuthenticationService
    private let alertRouter: AlertRouter
    private var sceneFactory: LoginSceneFactory

    init(authenticationService: AuthenticationService, alertRouter: AlertRouter) {
        self.authenticationService = authenticationService
        self.alertRouter = alertRouter
        
        sceneFactory = LoginViewControllerFactory()
    }

    func with(_ sceneFactory: LoginSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> LoginComponentFactory {
        LoginComponentFactoryImpl(
            sceneFactory: sceneFactory,
            authenticationService: authenticationService,
            alertRouter: alertRouter
        )
    }

}
