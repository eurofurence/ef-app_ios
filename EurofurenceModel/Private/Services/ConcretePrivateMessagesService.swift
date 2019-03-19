//
//  ConcretePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

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
        
        private let service: ConcretePrivateMessagesService
        
        init(service: ConcretePrivateMessagesService) {
            self.service = service
        }
        
        func consume(event: MessageImpl.ReadEvent) {
            service.state.markMessageAsRead(event.message)
        }
        
    }

    init(eventBus: EventBus, api: API) {
        self.eventBus = eventBus
        self.api = api
        
        eventBus.subscribe(userLoggedIn)
        eventBus.subscribe(userLoggedOut)
        eventBus.subscribe(consumer: MarkMessageAsReadHandler(service: self))
    }

    func add(_ observer: PrivateMessagesObserver) {
        observers.append(observer)
        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: determineUnreadMessageCount())
        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: localMessages)
    }

    func refreshMessages() {
        refreshMessages(completionHandler: nil)
    }

    func refreshMessages(completionHandler: (() -> Void)? = nil) {
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
        
        func refreshMessages(completionHandler: (() -> Void)? = nil) { }
        func markMessageAsRead(_ message: Message) { }
        
    }
    
    private class UnauthenticatedState: State {
        
        override func refreshMessages(completionHandler: (() -> Void)?) {
            service.notifyDidFailToLoadMessages()
            completionHandler?()
        }
        
    }
    
    private class AuthenticatedState: State {
        
        private let token: String
        
        init(service: ConcretePrivateMessagesService, token: String) {
            self.token = token
            super.init(service: service)
        }
        
        override func refreshMessages(completionHandler: (() -> Void)?) {
            service.api.loadPrivateMessages(authorizationToken: token) { (messages) in
                if let messages = messages {
                    self.service.updateEntities(from: messages)
                } else {
                    self.service.notifyDidFailToLoadMessages()
                }
                
                completionHandler?()
            }
        }
        
        override func markMessageAsRead(_ message: Message) {
            service.api.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
            service.updateObserversWithUnreadMessageCount()
        }
        
    }

}
