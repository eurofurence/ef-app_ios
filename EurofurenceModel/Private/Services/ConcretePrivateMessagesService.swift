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

    private var localMessages: [MessageImpl] = .empty
    
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

    private func determineUnreadMessageCount() -> Int {
        return localMessages.filter({ $0.isRead == false }).count
    }

    func refreshMessages() {
        refreshMessages(completionHandler: nil)
    }

    func refreshMessages(completionHandler: (() -> Void)? = nil) {
        if let token = userAuthenticationToken {
            api.loadPrivateMessages(authorizationToken: token) { (messages) in
                if let messages = messages {
                    let messages = messages.sorted(by: { (first, second) -> Bool in
                        return first.receivedDateTime.compare(second.receivedDateTime) == .orderedDescending
                    })

                    self.localMessages = messages.map(self.makeMessage)

                    let unreadCount = self.determineUnreadMessageCount()
                    self.privateMessageObservers.forEach({ (observer) in
                        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: unreadCount)
                        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: self.localMessages)
                    })
                } else {
                    for observer in self.privateMessageObservers {
                        observer.privateMessagesServiceDidFailToLoadMessages()
                    }
                }

                completionHandler?()
            }
        } else {
            for observer in privateMessageObservers {
                observer.privateMessagesServiceDidFailToLoadMessages()
            }

            completionHandler?()
        }
    }

    private func markMessageAsRead(_ message: Message) {
        guard let token = userAuthenticationToken else { return }
        api.markMessageWithIdentifierAsRead(message.identifier, authorizationToken: token)

        if let idx = localMessages.firstIndex(where: { $0.identifier == message.identifier  }) {
            var readMessage = localMessages[idx]
            readMessage.isRead = true
            localMessages[idx] = readMessage
        }

        let unreadCount = determineUnreadMessageCount()
        privateMessageObservers.forEach({ (observer) in
            observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: unreadCount)
        })
    }
    
    private func makeMessage(from characteristics: MessageCharacteristics) -> MessageImpl {
        return MessageImpl(eventBus: eventBus, characteristics: characteristics)
    }

    private func userLoggedIn(_ event: DomainEvent.LoggedIn) {
        userAuthenticationToken = event.authenticationToken
    }

}
