import EurofurenceModel
import UIKit.UIViewController

struct LoginModule: LoginModuleProviding {

    var sceneFactory: LoginSceneFactory
    var authenticationService: AuthenticationService
    var alertRouter: AlertRouter

    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeLoginScene()
        _ = LoginPresenter(delegate: delegate,
                           scene: scene,
                           authenticationService: authenticationService,
                           alertRouter: alertRouter)

        return scene
    }

}
