import Foundation

public protocol LongRunningTaskManager {

    func beginLongRunningTask() -> AnyHashable
    func finishLongRunningTask(token: AnyHashable)

}
