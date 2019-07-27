import UIKit

struct StoryboardHybridWebSceneFactory: HybridWebSceneFactory {

    private let storyboard = UIStoryboard(name: "HybridWeb", bundle: .main)

    func makeHybridWebScene() -> UIViewController & HybridWebScene {
        return storyboard.instantiate(HybridWebViewController.self)
    }

}
