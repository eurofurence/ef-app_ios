import UIKit

struct StoryboardCollectThemAllSceneFactory: CollectThemAllSceneFactory {

    private let storyboard = UIStoryboard(name: "CollectThemAll", bundle: .main)

    func makeCollectThemAllScene() -> UIViewController & CollectThemAllScene {
        return storyboard.instantiate(CollectThemAllViewController.self)
    }

}
