//
//  ConcretePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus

class ConcretePrivateMessagesService: PrivateMessagesService {

    private let api: API
    private var userAuthenticationToken: String?
    private var privateMessageObservers = [PrivateMessagesObserver]()

    private var localMessages: [MessageEntity] = .empty

    init(eventBus: EventBus, api: API) {
        self.api = api
        eventBus.subscribe(userLoggedIn)
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

                    self.localMessages = messages
                    let unreadCount = self.determineUnreadMessageCount()
                    self.privateMessageObservers.forEach({ (observer) in
                        observer.privateMessagesServiceDidUpdateUnreadMessageCount(to: unreadCount)
                        observer.privateMessagesServiceDidFinishRefreshingMessages(messages: messages)
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

    func markMessageAsRead(_ message: MessageEntity) {
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

    private func userLoggedIn(_ event: DomainEvent.LoggedIn) {
        userAuthenticationToken = event.authenticationToken
    }

}
