import UIKit.UIViewController

public protocol PreloadSceneFactory {

    func makePreloadScene() -> UIViewController & SplashScene

}
