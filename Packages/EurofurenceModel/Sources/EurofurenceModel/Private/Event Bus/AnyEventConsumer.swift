struct AnyEventConsumer {
    
    private let erased: Any
    private let _handle: (Any) -> Void
    
    init<Consumer>(_ consumer: Consumer) where Consumer: EventConsumer {
        self.erased = consumer
        
        _handle = { (event) in
            if let event = event as? Consumer.Event {
                consumer.consume(event: event)
            }
        }
    }
    
    @inline(__always)
    func handle(event: Any) {
        _handle(event)
    }
    
}

// MARK: - AnyEventConsumer + CustomReflectable

extension AnyEventConsumer: CustomReflectable {
    
    var customMirror: Mirror {
        Mirror(reflecting: erased)
    }
    
}
