import UIKit.UIViewController

protocol PreloadSceneFactory {

    func makePreloadScene() -> UIViewController & SplashScene

}
