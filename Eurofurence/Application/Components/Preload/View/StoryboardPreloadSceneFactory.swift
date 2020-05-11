import UIKit.UIStoryboard
import UIKit.UIViewController

public struct StoryboardPreloadSceneFactory: PreloadSceneFactory {

    private let storyboard = UIStoryboard(name: "Preload", bundle: .main)
    
    public init() {
        
    }

    public func makePreloadScene() -> UIViewController & SplashScene {
        return storyboard.instantiate(PreloadViewController.self)
    }

}
