import UIKit.UIViewController

protocol NewsSceneFactory {

    func makeNewsScene() -> UIViewController & NewsScene

}
