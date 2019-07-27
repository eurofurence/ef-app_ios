import Foundation

public extension EventBus {

    func subscribe<T>(_ block: @escaping (T) -> Void) {
        let consumer = BlockEventConsumer(block: block)
        subscribe(consumer: consumer)
    }

}
