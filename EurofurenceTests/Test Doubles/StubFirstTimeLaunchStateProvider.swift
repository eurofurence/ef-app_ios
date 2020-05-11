import Eurofurence
import EurofurenceModel
import Foundation

class StubFirstTimeLaunchStateProvider: UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool

    init(userHasCompletedTutorial: Bool) {
        self.userHasCompletedTutorial = userHasCompletedTutorial
    }

    private(set) var didMarkTutorialAsComplete = false
    func markTutorialAsComplete() {
        didMarkTutorialAsComplete = true
    }

}
