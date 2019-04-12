@testable import Eurofurence
import EurofurenceModel

class CapturingTutorialModuleDelegate: TutorialModuleDelegate {

    private(set) var wasToldTutorialFinished = false
    func tutorialModuleDidFinishPresentingTutorial() {
        wasToldTutorialFinished = true
    }

}
