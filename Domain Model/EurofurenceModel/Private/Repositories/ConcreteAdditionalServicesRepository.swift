import EventBus

class ConcreteAdditionalServicesRepository: AdditionalServicesRepository {
    
    private let companionAppURLRequestFactory: CompanionAppURLRequestFactory
    private var consumers = [AdditionalServicesURLConsumer]()
    private var currentAdditionalServicesRequest: URLRequest
    
    init(eventBus: EventBus, companionAppURLRequestFactory: CompanionAppURLRequestFactory) {
        self.companionAppURLRequestFactory = companionAppURLRequestFactory
        currentAdditionalServicesRequest = companionAppURLRequestFactory.makeAdditionalServicesRequest(authenticationToken: nil)
        
        eventBus.subscribe(loggedIn)
        eventBus.subscribe(loggedOut)
    }
    
    func add(_ additionalServicesURLConsumer: AdditionalServicesURLConsumer) {
        consumers.append(additionalServicesURLConsumer)
        additionalServicesURLConsumer.consume(currentAdditionalServicesRequest)
    }
    
    private func loggedOut(_ event: DomainEvent.LoggedOut) {
        currentAdditionalServicesRequest = companionAppURLRequestFactory.makeAdditionalServicesRequest(authenticationToken: nil)
        updateConsumersWithChangedServicesRequest()
    }
    
    private func loggedIn(_ event: DomainEvent.LoggedIn) {
        currentAdditionalServicesRequest = companionAppURLRequestFactory.makeAdditionalServicesRequest(authenticationToken: event.authenticationToken)
        updateConsumersWithChangedServicesRequest()
    }
    
    private func updateConsumersWithChangedServicesRequest() {
        consumers.forEach({ $0.consume(currentAdditionalServicesRequest) })
    }
    
}
