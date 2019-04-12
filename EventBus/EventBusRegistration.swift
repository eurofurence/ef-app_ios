protocol EventBusRegistration {

    func supports<T>(_ event: T) -> Bool
    func represents<Consumer: EventConsumer>(consumer: Consumer) -> Bool
    func handle(event: Any)

}
