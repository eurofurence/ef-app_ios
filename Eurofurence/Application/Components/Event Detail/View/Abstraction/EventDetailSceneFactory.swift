import UIKit.UIViewController

protocol EventDetailSceneFactory {

    func makeEventDetailScene() -> UIViewController & EventDetailScene

}
