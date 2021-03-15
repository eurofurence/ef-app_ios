import UIKit.UIStoryboard

public struct StoryboardTutorialSceneFactory: TutorialSceneFactory {

    private let storyboard = UIStoryboard(name: "Tutorial", bundle: .module)
    
    public init() {
        
    }

    public func makeTutorialScene() -> UIViewController & TutorialScene {
        return storyboard.instantiate(TutorialViewController.self)
    }

}
