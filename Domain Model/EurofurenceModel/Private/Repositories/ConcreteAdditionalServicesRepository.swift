import EventBus

class ConcreteAdditionalServicesRepository: AdditionalServicesRepository {
    
    private let companionAppURLRequestFactory: CompanionAppURLRequestFactory
    private var consumers = [AdditionalServicesURLConsumer]()
    private var authenticationToken: String?
    
    init(eventBus: EventBus, companionAppURLRequestFactory: CompanionAppURLRequestFactory) {
        self.companionAppURLRequestFactory = companionAppURLRequestFactory
        
        eventBus.subscribe(loggedIn)
        eventBus.subscribe(loggedOut)
    }
    
    func add(_ additionalServicesURLConsumer: AdditionalServicesURLConsumer) {
        consumers.append(additionalServicesURLConsumer)
        
        let request = companionAppURLRequestFactory.makeAdditionalServicesRequest(authenticationToken: authenticationToken)
        additionalServicesURLConsumer.consume(request)
    }
    
    private func loggedOut(_ event: DomainEvent.LoggedOut) {
        authenticationToken = nil
        
        consumers.forEach { (additionalServicesURLConsumer) in
            let request = companionAppURLRequestFactory.makeAdditionalServicesRequest(authenticationToken: authenticationToken)
            additionalServicesURLConsumer.consume(request)
        }
    }
    
    private func loggedIn(_ event: DomainEvent.LoggedIn) {
        authenticationToken = event.authenticationToken
        
        consumers.forEach { (additionalServicesURLConsumer) in
            let request = companionAppURLRequestFactory.makeAdditionalServicesRequest(authenticationToken: authenticationToken)
            additionalServicesURLConsumer.consume(request)
        }
    }
    
}
