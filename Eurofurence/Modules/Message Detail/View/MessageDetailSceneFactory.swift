import UIKit.UIViewController

protocol MessageDetailSceneFactory {

    func makeMessageDetailScene() -> UIViewController & MessageDetailScene

}
