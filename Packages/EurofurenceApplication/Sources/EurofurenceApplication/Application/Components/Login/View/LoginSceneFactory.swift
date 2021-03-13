import UIKit.UIViewController

public protocol LoginSceneFactory {

    func makeLoginScene() -> UIViewController & LoginScene

}
