import EventBus
import Foundation

class ConcreteCollectThemAllService: CollectThemAllService {

    private let collectThemAllRequestFactory: CollectThemAllRequestFactory
    private let credentialRepository: CredentialRepository

    init(
        eventBus: EventBus,
        collectThemAllRequestFactory: CollectThemAllRequestFactory,
        credentialRepository: CredentialRepository
    ) {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialRepository = credentialRepository

        eventBus.subscribe(consumer: UpdateCollectThemAllRequestWhenAuthenticated(service: self))
        eventBus.subscribe(consumer: UpdateCollectThemAllRequestWhenUnauthenticated(service: self))
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
    
    private struct UpdateCollectThemAllRequestWhenAuthenticated: EventConsumer {

        private unowned let service: ConcreteCollectThemAllService

        init(service: ConcreteCollectThemAllService) {
            self.service = service
        }

        func consume(event: DomainEvent.LoggedOut) {
            service.notifyObserversGameRequestDidChange()
        }

    }

    private struct UpdateCollectThemAllRequestWhenUnauthenticated: EventConsumer {

        private unowned let service: ConcreteCollectThemAllService

        init(service: ConcreteCollectThemAllService) {
            self.service = service
        }

        func consume(event: DomainEvent.LoggedIn) {
            service.notifyObserversGameRequestDidChange()
        }

    }

}
