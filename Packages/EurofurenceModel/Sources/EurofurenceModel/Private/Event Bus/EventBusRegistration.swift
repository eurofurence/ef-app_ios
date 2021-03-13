protocol EventBusRegistration {

    func supports<T>(_ event: T) -> Bool
    func handle(event: Any)

}
