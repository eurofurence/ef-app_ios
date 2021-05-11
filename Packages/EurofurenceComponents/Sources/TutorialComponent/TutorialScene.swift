import UIKit.UIViewController

public protocol TutorialSceneFactory {

    func makeTutorialScene() -> UIViewController & TutorialScene

}

public protocol TutorialScene: AnyObject {

    func showTutorialPage() -> TutorialPageScene

}
