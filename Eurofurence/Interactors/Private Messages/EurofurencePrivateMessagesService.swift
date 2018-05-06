//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class EurofurencePrivateMessagesService: PrivateMessagesService {

    static var shared = EurofurencePrivateMessagesService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol
    private var observers = [PrivateMessagesServiceObserver]()

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
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
        let count = app.localPrivateMessages.filter(isUnread).count
        unreadMessageCountObserver.privateMessagesServiceDidUpdateUnreadMessageCount(to: count)
    }

}
