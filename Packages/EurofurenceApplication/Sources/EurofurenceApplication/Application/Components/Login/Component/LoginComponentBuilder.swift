import ComponentBase
import EurofurenceModel

public class LoginComponentBuilder {

    private let authenticationService: AuthenticationService
    private let alertRouter: AlertRouter
    private var sceneFactory: LoginSceneFactory

    public init(authenticationService: AuthenticationService, alertRouter: AlertRouter) {
        self.authenticationService = authenticationService
        self.alertRouter = alertRouter
        
        sceneFactory = LoginViewControllerFactory()
    }

    public func with(_ sceneFactory: LoginSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func build() -> LoginComponentFactory {
        LoginComponentFactoryImpl(
            sceneFactory: sceneFactory,
            authenticationService: authenticationService,
            alertRouter: alertRouter
        )
    }

}
