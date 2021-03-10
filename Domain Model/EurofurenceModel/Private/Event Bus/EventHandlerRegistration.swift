struct EventConsumerRegistration<Consumer: EventConsumer>: EventBusRegistration {

    // MARK: Properties

    let consumer: Consumer

    // MARK: EventBusRegistration

    func supports<T>(_ event: T) -> Bool {
        return event is Consumer.Event
    }

    func handle(event: Any) {
        guard let consumerEvent = event as? Consumer.Event else {
            fatalError("Consumer expected \(Consumer.Event.self), got \(event)")
        }

        consumer.consume(event: consumerEvent)
    }

}
