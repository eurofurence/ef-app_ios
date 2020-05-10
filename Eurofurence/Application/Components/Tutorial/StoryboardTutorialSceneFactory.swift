import UIKit.UIStoryboard

struct StoryboardTutorialSceneFactory: TutorialSceneFactory {

    private let storyboard = UIStoryboard(name: "Tutorial", bundle: .main)

    func makeTutorialScene() -> UIViewController & TutorialScene {
        return storyboard.instantiate(TutorialViewController.self)
    }

}
