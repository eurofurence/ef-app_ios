import Foundation

class ConcreteAdditionalServicesRepository: AdditionalServicesRepository {
    
    private let companionAppURLRequestFactory: CompanionAppURLRequestFactory
    private var subscriptions = Set<AnyHashable>()
    private var consumers = [AdditionalServicesURLConsumer]()
    private var currentAdditionalServicesRequest: URLRequest
    
    private struct UseUnauthenticatedServicesOnLogout: EventConsumer {
        
        private unowned let controller: ConcreteAdditionalServicesRepository
        
        init(controller: ConcreteAdditionalServicesRepository) {
            self.controller = controller
        }
        
        func consume(event: DomainEvent.LoggedOut) {
            controller.useUnauthenticatedAdditionalServices()
        }
        
    }
    
    private struct UseAuthenticatedServicesWhenLoggedIn: EventConsumer {
        
        private unowned let controller: ConcreteAdditionalServicesRepository
        
        init(controller: ConcreteAdditionalServicesRepository) {
            self.controller = controller
        }
        
        func consume(event: DomainEvent.LoggedIn) {
            controller.useAuthenticatedAdditionalServices(token: event.authenticationToken)
        }
        
    }
    
    init(eventBus: EventBus, companionAppURLRequestFactory: CompanionAppURLRequestFactory) {
        self.companionAppURLRequestFactory = companionAppURLRequestFactory
        currentAdditionalServicesRequest = companionAppURLRequestFactory.makeAdditionalServicesRequest(
            authenticationToken: nil
        )
        
        subscriptions.insert(eventBus.subscribe(consumer: UseAuthenticatedServicesWhenLoggedIn(controller: self)))
        subscriptions.insert(eventBus.subscribe(consumer: UseUnauthenticatedServicesOnLogout(controller: self)))
    }
    
    func add(_ additionalServicesURLConsumer: AdditionalServicesURLConsumer) {
        consumers.append(additionalServicesURLConsumer)
        additionalServicesURLConsumer.consume(currentAdditionalServicesRequest)
    }
    
    private func useUnauthenticatedAdditionalServices() {
        currentAdditionalServicesRequest = companionAppURLRequestFactory.makeAdditionalServicesRequest(
            authenticationToken: nil
        )
        
        updateConsumersWithChangedServicesRequest()
    }
    
    private func useAuthenticatedAdditionalServices(token: String) {
        currentAdditionalServicesRequest = companionAppURLRequestFactory.makeAdditionalServicesRequest(
            authenticationToken: token
        )
        
        updateConsumersWithChangedServicesRequest()
    }
    
    private func updateConsumersWithChangedServicesRequest() {
        consumers.forEach({ $0.consume(currentAdditionalServicesRequest) })
    }
    
}
