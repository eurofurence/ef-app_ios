//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

class EurofurencePrivateMessagesService: PrivateMessagesService, PrivateMessagesObserver {

    static var shared = EurofurencePrivateMessagesService(app: SharedModel.instance.session)

    private let app: EurofurenceApplicationProtocol
    private var observers = [PrivateMessagesServiceObserver]()
    private var messages: [Message] = []

    init(app: EurofurenceApplicationProtocol) {
        self.app = app

        messages = app.localPrivateMessages
        app.add(self)
    }

    func eurofurenceApplicationDidLoad(messages: [Message]) {
        self.messages = messages
        observers.forEach(provideUnreadMessageCount)
    }

    func add(_ observer: PrivateMessagesServiceObserver) {
        observers.append(observer)
        provideUnreadMessageCount(to: observer)
    }

    func refreshMessages() {
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

    func markMessageAsRead(_ message: Message) {
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
