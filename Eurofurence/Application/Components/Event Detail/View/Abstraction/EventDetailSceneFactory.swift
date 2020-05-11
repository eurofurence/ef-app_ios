import UIKit.UIViewController

public protocol EventDetailSceneFactory {

    func makeEventDetailScene() -> UIViewController & EventDetailScene

}
