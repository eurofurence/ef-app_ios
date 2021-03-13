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
        let stubTaskToken = String.random
        self.stubTaskToken = stubTaskToken
        state = .running
        
        return stubTaskToken
    }

    func finishLongRunningTask(token: AnyHashable) {
        if token == stubTaskToken {
            state = .ended
        } else {
            state = .wrongToken
        }
    }

}

class JournallingLongRunningTaskManager: FakeLongRunningTaskManager {
    
    private(set) var longRunningTaskCount = 0
    
    override func beginLongRunningTask() -> AnyHashable {
        longRunningTaskCount += 1
        return super.beginLongRunningTask()
    }
    
    override func finishLongRunningTask(token: AnyHashable) {
        super.finishLongRunningTask(token: token)
        longRunningTaskCount -= 1
    }
    
}
