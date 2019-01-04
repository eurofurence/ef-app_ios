//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public class EurofurencePrivateMessagesService: PrivateMessagesService, PrivateMessagesObserver {

    private let app: PrivateMessagesService2
    private var observers = [PrivateMessagesServiceObserver]()
    private var messages: [Message] = []

    public init(app: PrivateMessagesService2) {
        self.app = app

        messages = app.localPrivateMessages
        app.add(self)
    }

    public func eurofurenceApplicationDidLoad(messages: [Message]) {
        self.messages = messages
        observers.forEach(provideUnreadMessageCount)
    }

    public func add(_ observer: PrivateMessagesServiceObserver) {
        observers.append(observer)
        provideUnreadMessageCount(to: observer)
    }

    public func refreshMessages() {
        if !app.localPrivateMessages.isEmpty {
            observers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(app.localPrivateMessages) })
        }

        app.fetchPrivateMessages { (result) in
            switch result {
            case .success(let messages):
                self.messages = self.app.localPrivateMessages
                self.observers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages) })
                self.observers.forEach(self.provideUnreadMessageCount)

            default:
                self.observers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
            }
        }
    }

    public func markMessageAsRead(_ message: Message) {
        app.markMessageAsRead(message)
    }

    private func isUnread(_ message: Message) -> Bool {
        return !message.isRead
    }

    private func provideUnreadMessageCount(to unreadMessageCountObserver: PrivateMessagesServiceObserver) {
        let count = messages.filter(isUnread).count
        unreadMessageCountObserver.privateMessagesServiceDidUpdateUnreadMessageCount(to: count)
    }

}
