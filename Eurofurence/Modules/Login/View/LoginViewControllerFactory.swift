import UIKit.UIStoryboard
import UIKit.UIViewController

struct LoginViewControllerFactory: LoginSceneFactory {

    private let storyboard = UIStoryboard(name: "Login", bundle: .main)

    func makeLoginScene() -> UIViewController & LoginScene {
        return storyboard.instantiate(LoginViewController.self)
    }

}
