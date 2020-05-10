import UIKit.UIViewController

protocol TutorialSceneFactory {

    func makeTutorialScene() -> UIViewController & TutorialScene

}

protocol TutorialScene: class {

    func showTutorialPage() -> TutorialPageScene

}
