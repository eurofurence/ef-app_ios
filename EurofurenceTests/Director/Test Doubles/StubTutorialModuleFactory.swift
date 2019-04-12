@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class StubTutorialModuleFactory: TutorialModuleProviding {

    let stubInterface = UIViewController()
    private(set) var delegate: TutorialModuleDelegate?
    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubTutorialModuleFactory {

    func simulateTutorialFinished() {
        delegate?.tutorialModuleDidFinishPresentingTutorial()
    }

}
