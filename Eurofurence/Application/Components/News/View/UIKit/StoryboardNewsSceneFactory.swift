import UIKit.UIStoryboard

struct StoryboardNewsSceneFactory: NewsSceneFactory {

    private let storyboard = UIStoryboard(name: "News", bundle: .main)

    func makeNewsScene() -> UIViewController & NewsScene {
        return storyboard.instantiate(NewsViewController.self)
    }

}
