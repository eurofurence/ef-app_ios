import UIKit

struct StoryboardHybridWebSceneFactory: HybridWebSceneFactory {

    private let storyboard = UIStoryboard(name: "HybridWeb", bundle: .module)

    func makeHybridWebScene() -> UIViewController & HybridWebScene {
        return storyboard.instantiate(HybridWebViewController.self)
    }

}
