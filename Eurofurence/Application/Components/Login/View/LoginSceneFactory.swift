import UIKit.UIViewController

protocol LoginSceneFactory {

    func makeLoginScene() -> UIViewController & LoginScene

}
