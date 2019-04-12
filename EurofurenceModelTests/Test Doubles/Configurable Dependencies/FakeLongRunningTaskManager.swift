import EurofurenceModel
import Foundation

class FakeLongRunningTaskManager: LongRunningTaskManager {
    
    enum State {
        case notStarted
        case running
        case ended
        case wrongToken
    }

    private(set) var state: State = .notStarted

    private var stubTaskToken: AnyHashable?
    private(set) var didBeginTask = false
    func beginLongRunningTask() -> AnyHashable {
        stubTaskToken = String.random
        state = .running
        
        return stubTaskToken!
    }

    func finishLongRunningTask(token: AnyHashable) {
        if token == stubTaskToken {
            state = .ended
        } else {
            state = .wrongToken
        }
    }

}
