import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController

class StubTutorialComponentFactory: TutorialComponentFactory {

    let stubInterface = UIViewController()
    private(set) var delegate: TutorialComponentDelegate?
    func makeTutorialModule(_ delegate: TutorialComponentDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubTutorialComponentFactory {

    func simulateTutorialFinished() {
        delegate?.tutorialModuleDidFinishPresentingTutorial()
    }

}
