import ComponentBase
import EurofurenceModel
import UIKit.UIViewController

struct LoginComponentFactoryImpl: LoginComponentFactory {

    var sceneFactory: LoginSceneFactory
    var authenticationService: AuthenticationService
    var alertRouter: AlertRouter

    func makeLoginModule(_ delegate: LoginComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeLoginScene()
        _ = LoginPresenter(
            delegate: delegate,
            scene: scene,
            authenticationService: authenticationService,
            alertRouter: alertRouter
        )

        return scene
    }

}
