import UIKit.UIViewController

public protocol TutorialSceneFactory {

    func makeTutorialScene() -> UIViewController & TutorialScene

}

public protocol TutorialScene: class {

    func showTutorialPage() -> TutorialPageScene

}
