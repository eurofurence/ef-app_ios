public struct BlockEventConsumer<T>: EventConsumer {

    private let block: (T) -> Void

    public init(block: @escaping (T) -> Void) {
        self.block = block
    }

    public typealias Event = T

    public func consume(event: BlockEventConsumer.Event) {
        block(event)
    }

}
