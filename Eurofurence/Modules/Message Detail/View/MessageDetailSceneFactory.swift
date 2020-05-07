import UIKit.UIViewController

public protocol MessageDetailSceneFactory {

    func makeMessageDetailScene() -> UIViewController & MessageDetailScene

}
