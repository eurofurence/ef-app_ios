import UIKit.UIStoryboard

struct StoryboardNewsSceneFactory: NewsSceneFactory {

    private let storyboard = UIStoryboard(name: "News", bundle: .module)

    func makeNewsScene() -> UIViewController & NewsScene {
        return storyboard.instantiate(NewsViewController.self)
    }

}
