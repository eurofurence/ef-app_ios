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
    private var userAuthenticationToken: String?
    private var privateMessageObservers = [PrivateMessagesObserver]()

    private var localMessages: [MessageImpl] = .empty {
        didSet {
            privateMessageObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: localMessages) })
        }
    }
    
    private class MarkMessageAsReadHandler: EventConsumer {
        
        private let service: ConcretePrivateMessagesService
        
        init(service: ConcretePrivateMessagesService) {
            self.service = service
        }
        
        func consume(event: MessageImpl.ReadEvent) {
            service.markMessageAsRead(event.message)
        }
        
    }

    init(eventBus: EventBus, api: API) {
        self.eventBus = eventBus
        self.api = api
        
        eventBus.subscribe(userLoggedIn)
        eventBus.subscribe(consumer: MarkMessageAsReadHandler(service: self))
    }

    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: determineUnreadMessageCount())
        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: localMessages)
    }

    func refreshMessages() {
        refreshMessages(completionHandler: nil)
    }

    func refreshMessages(completionHandler: (() -> Void)? = nil) {
        if let token = userAuthenticationToken {
            refreshMessages(token: token, completionHandler: completionHandler)
        } else {
            notifyDidFailToLoadMessages()
            completionHandler?()
        }
    }
    
    private func refreshMessages(token: String, completionHandler: (() -> Void)?) {
        api.loadPrivateMessages(authorizationToken: token) { (messages) in
            if let messages = messages {
                self.updateEntities(from: messages)
            } else {
                self.notifyDidFailToLoadMessages()
            }

            completionHandler?()
        }
    }
    
    private func updateEntities(from messages: [MessageCharacteristics]) {
        localMessages = messages.map(makeMessage).sorted()
        updateObserversWithUnreadMessageCount()
    }
    
    private func notifyDidFailToLoadMessages() {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
    }

    private func updateObserversWithUnreadMessageCount() {
        let unreadCount = determineUnreadMessageCount()
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: unreadCount) })
    }
    
    private func determineUnreadMessageCount() -> Int {
        return localMessages.filter({ $0.isRead == false }).count
    }
    
    private func markMessageAsRead(_ message: Message) {
        guard let token = userAuthenticationToken else { return }
        
        api.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)
        updateObserversWithUnreadMessageCount()
    }
    
    private func makeMessage(from characteristics: MessageCharacteristics) -> MessageImpl {
        return MessageImpl(eventBus: eventBus, characteristics: characteristics)
    }

    private func userLoggedIn(_ event: DomainEvent.LoggedIn) {
        userAuthenticationToken = event.authenticationToken
    }

}
