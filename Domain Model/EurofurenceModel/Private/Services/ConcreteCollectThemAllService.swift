import EventBus
import Foundation

class ConcreteCollectThemAllService: CollectThemAllService {

    private class LoggedOut: EventConsumer {

        private let handler: () -> Void

        init(handler: @escaping () -> Void) {
            self.handler = handler
        }

        func consume(event: DomainEvent.LoggedOut) {
            handler()
        }

    }

    private class LoggedIn: EventConsumer {

        private let handler: () -> Void

        init(handler: @escaping () -> Void) {
            self.handler = handler
        }

        func consume(event: DomainEvent.LoggedIn) {
            handler()
        }

    }

    private let collectThemAllRequestFactory: CollectThemAllRequestFactory
    private let credentialRepository: CredentialRepository

    init(eventBus: EventBus,
         collectThemAllRequestFactory: CollectThemAllRequestFactory,
         credentialRepository: CredentialRepository) {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialRepository = credentialRepository

        eventBus.subscribe(consumer: LoggedOut { [weak self] in
            self?.notifyObserversGameRequestDidChange()
        })
        
        eventBus.subscribe(consumer: LoggedIn { [weak self] in
            self?.notifyObserversGameRequestDidChange()
        })
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

}
