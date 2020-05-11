import UIKit.UIViewController

public protocol NewsSceneFactory {

    func makeNewsScene() -> UIViewController & NewsScene

}
