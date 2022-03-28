import Foundation

public extension EventBus {

    func subscribe<T>(_ block: @escaping (T) -> Void) -> Any {
        let consumer = BlockEventConsumer(block: block)
        return subscribe(consumer: consumer)
    }

}
