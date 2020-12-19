import EventBus

class ConcretePrivateMessagesService: PrivateMessagesService {

    private let eventBus: EventBus
    private let api: API
    private lazy var state: State = UnauthenticatedState(service: self)
    private var observers = [PrivateMessagesObserver]()

    private var localMessages: [MessageImpl] = .empty {
        didSet {
            observers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: localMessages) })
        }
    }
    
    private class MarkMessageAsReadHandler: EventConsumer {
        
        private unowned let service: ConcretePrivateMessagesService
        
        init(service: ConcretePrivateMessagesService) {
            self.service = service
        }
        
        func consume(event: MessageImpl.ReadEvent) {
            service.state.markMessageAsRead(event.message)
        }
        
    }
    
    private class EnterAuthenticatedStateWhenLoggedIn: EventConsumer {
        
        private unowned let service: ConcretePrivateMessagesService
        
        init(service: ConcretePrivateMessagesService) {
            self.service = service
        }
        
        func consume(event: DomainEvent.LoggedIn) {
            service.userLoggedIn(event)
        }
        
    }
    
    private class ExitAuthenticatedStateWhenLoggedOut: EventConsumer {
        
        private unowned let service: ConcretePrivateMessagesService
        
        init(service: ConcretePrivateMessagesService) {
            self.service = service
        }
        
        func consume(event: DomainEvent.LoggedOut) {
            service.userLoggedOut(event)
        }
        
    }

    init(eventBus: EventBus, api: API) {
        self.eventBus = eventBus
        self.api = api
        
        eventBus.subscribe(consumer: EnterAuthenticatedStateWhenLoggedIn(service: self))
        eventBus.subscribe(consumer: ExitAuthenticatedStateWhenLoggedOut(service: self))
        eventBus.subscribe(consumer: MarkMessageAsReadHandler(service: self))
    }

    func add(_ observer: PrivateMessagesObserver) {
        observers.append(observer)
        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: determineUnreadMessageCount())
        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: localMessages)
    }
    
    func removeObserver(_ observer: PrivateMessagesObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    func refreshMessages() {
        refreshMessages(completionHandler: nil)
    }
    
    func fetchMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void
    ) {
        if let message = findMessage(identifiedBy: identifier) {
            completionHandler(.success(message))
        } else {
            refreshMessagesWithIntentToAcquireMessage(identifiedBy: identifier, completionHandler: completionHandler)
        }
    }
    
    private func findMessage(identifiedBy identifier: MessageIdentifier) -> Message? {
        localMessages.first(where: { $0.identifier == identifier })
    }
    
    private func refreshMessagesWithIntentToAcquireMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void
    ) {
        refreshMessages(completionHandler: { (result) in
            if result == nil {
                completionHandler(.failure(.loadingMessagesFailed))
            } else {
                if let message = self.findMessage(identifiedBy: identifier) {
                    completionHandler(.success(message))
                } else {
                    completionHandler(.failure(.noMessageFound))
                }
            }
        })
    }

    func refreshMessages(completionHandler: (([MessageCharacteristics]?) -> Void)? = nil) {
        state.refreshMessages(completionHandler: completionHandler)
    }
    
    private func updateEntities(from messages: [MessageCharacteristics]) {
        localMessages = messages.map(makeMessage).sorted()
        updateObserversWithUnreadMessageCount()
    }
    
    private func notifyDidFailToLoadMessages() {
        observers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
    }

    private func updateObserversWithUnreadMessageCount() {
        let unreadCount = determineUnreadMessageCount()
        observers.forEach({ $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: unreadCount) })
    }
    
    private func determineUnreadMessageCount() -> Int {
        return localMessages.filter({ $0.isRead == false }).count
    }
    
    private func makeMessage(from characteristics: MessageCharacteristics) -> MessageImpl {
        return MessageImpl(eventBus: eventBus, characteristics: characteristics)
    }

    private func userLoggedIn(_ event: DomainEvent.LoggedIn) {
        state = AuthenticatedState(service: self, token: event.authenticationToken)
    }
    
    private func userLoggedOut(_ event: DomainEvent.LoggedOut) {
        localMessages.removeAll()
        state = UnauthenticatedState(service: self)
    }
    
    // MARK: State Machine
    
    private class State {
        
        unowned let service: ConcretePrivateMessagesService
        
        init(service: ConcretePrivateMessagesService) {
            self.service = service
        }
        
        func refreshMessages(completionHandler: (([MessageCharacteristics]?) -> Void)? = nil) { }
        func markMessageAsRead(_ message: Message) { }
        
    }
    
    private class UnauthenticatedState: State {
        
        override func refreshMessages(completionHandler: (([MessageCharacteristics]?) -> Void)?) {
            service.notifyDidFailToLoadMessages()
            completionHandler?(nil)
        }
        
    }
    
    private class AuthenticatedState: State {
        
        private let token: String
        
        init(service: ConcretePrivateMessagesService, token: String) {
            self.token = token
            super.init(service: service)
        }
        
        override func refreshMessages(completionHandler: (([MessageCharacteristics]?) -> Void)?) {
            service.api.loadPrivateMessages(authorizationToken: token) { (messages) in
                if let messages = messages {
                    self.service.updateEntities(from: messages)
                } else {
                    self.service.notifyDidFailToLoadMessages()
                }
                
                completionHandler?(messages)
            }
        }
        
        override func markMessageAsRead(_ message: Message) {
            service.api.markMessageWithIdentifierAsRead(message.identifier.rawValue, authorizationToken: token)
            service.updateObserversWithUnreadMessageCount()
        }
        
    }

}
