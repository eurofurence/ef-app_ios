@testable import Eurofurence
import EurofurenceModel

class CapturingTutorialComponentDelegate: TutorialComponentDelegate {

    private(set) var wasToldTutorialFinished = false
    func tutorialModuleDidFinishPresentingTutorial() {
        wasToldTutorialFinished = true
    }

}
