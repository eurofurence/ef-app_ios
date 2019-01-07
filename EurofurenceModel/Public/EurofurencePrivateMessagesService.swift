//
//  EurofurencePrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public class EurofurencePrivateMessagesService: PrivateMessagesService, PrivateMessagesObserver {
    
    public func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        
    }
    
    public func privateMessagesServiceDidFailToLoadMessages() {
        
    }
    

    private let app: PrivateMessagesService2
    private var observers = [PrivateMessagesServiceObserver]()
    private var messages: [APIMessage] = []

    public init(app: PrivateMessagesService2) {
        self.app = app

        messages = app.localMessages
        app.add(self)
    }

    public func privateMessagesServiceDidFinishRefreshingMessages(messages: [APIMessage]) {
        self.messages = messages
        observers.forEach(provideUnreadMessageCount)
    }

    public func add(_ observer: PrivateMessagesServiceObserver) {
        observers.append(observer)
        provideUnreadMessageCount(to: observer)
    }

    public func refreshMessages() {
        if !app.localMessages.isEmpty {
            observers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(app.localMessages) })
        }

        app.fetchPrivateMessages { (result) in
            switch result {
            case .success(let messages):
                self.messages = self.app.localMessages
                self.observers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages) })
                self.observers.forEach(self.provideUnreadMessageCount)

            default:
                self.observers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
            }
        }
    }

    public func markMessageAsRead(_ message: APIMessage) {
        app.markMessageAsRead(message)
    }

    private func isUnread(_ message: APIMessage) -> Bool {
        return !message.isRead
    }

    private func provideUnreadMessageCount(to unreadMessageCountObserver: PrivateMessagesServiceObserver) {
        let count = messages.filter(isUnread).count
        unreadMessageCountObserver.privateMessagesServiceDidUpdateUnreadMessageCount(to: count)
    }

}
