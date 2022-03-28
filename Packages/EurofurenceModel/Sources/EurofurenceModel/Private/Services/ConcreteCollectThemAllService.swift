import Foundation

class ConcreteCollectThemAllService: CollectThemAllService {

    private let collectThemAllRequestFactory: CollectThemAllRequestFactory
    private let credentialRepository: CredentialRepository
    private var subscriptions = Set<AnyHashable>()

    init(
        eventBus: EventBus,
        collectThemAllRequestFactory: CollectThemAllRequestFactory,
        credentialRepository: CredentialRepository
    ) {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialRepository = credentialRepository

        subscriptions.insert(eventBus.subscribe(consumer: UpdateRequestWhenAuthenticated(service: self)))
        subscriptions.insert(eventBus.subscribe(consumer: UpdateRequestWhenUnauthenticated(service: self)))
    }

    private var collectThemAllRequestObservers = [CollectThemAllURLObserver]()
    func subscribe(_ observer: CollectThemAllURLObserver) {
        collectThemAllRequestObservers.append(observer)
        provideLatestRequestToObserver(observer)
    }

    private func notifyObserversGameRequestDidChange() {
        collectThemAllRequestObservers.forEach(provideLatestRequestToObserver)
    }

    private func provideLatestRequestToObserver(_ observer: CollectThemAllURLObserver) {
        let request: URLRequest = credentialRepository.persistedCredential
            .map(collectThemAllRequestFactory.makeAuthenticatedGameURLRequest)
            .defaultingTo(collectThemAllRequestFactory.makeAnonymousGameURLRequest())

        observer.collectThemAllGameRequestDidChange(request)
    }
    
    private struct UpdateRequestWhenAuthenticated: EventConsumer {

        private unowned let service: ConcreteCollectThemAllService

        init(service: ConcreteCollectThemAllService) {
            self.service = service
        }

        func consume(event: DomainEvent.LoggedOut) {
            service.notifyObserversGameRequestDidChange()
        }

    }

    private struct UpdateRequestWhenUnauthenticated: EventConsumer {

        private unowned let service: ConcreteCollectThemAllService

        init(service: ConcreteCollectThemAllService) {
            self.service = service
        }

        func consume(event: DomainEvent.LoggedIn) {
            service.notifyObserversGameRequestDidChange()
        }

    }

}
