//
//  CapturingPrivateMessagesService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingPrivateMessagesService: PrivateMessagesService, PrivateMessagesService2 {

    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {

    }

    private var privateMessageObservers = [PrivateMessagesObserver]()
    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }

    var unreadMessageCount: Int = 0
    var localMessages: [APIMessage] = []

    init(unreadMessageCount: Int = 0, localMessages: [APIMessage] = []) {
        self.localMessages = localMessages
    }

    private(set) var wasToldToRefreshMessages = false
    private(set) var refreshMessagesCount = 0
    func refreshMessages() {
        wasToldToRefreshMessages = true
        refreshMessagesCount += 1
    }

    private var observers = [PrivateMessagesServiceObserver]()
    func add(_ observer: PrivateMessagesServiceObserver) {
        observers.append(observer)
    }

    private(set) var messageMarkedAsRead: APIMessage?
    func markMessageAsRead(_ message: APIMessage) {
        messageMarkedAsRead = message
    }

    func failLastRefresh() {
        observers.forEach { $0.privateMessagesServiceDidFailToLoadMessages() }
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
    }

    func succeedLastRefresh(messages: [APIMessage] = []) {
        observers.forEach { $0.privateMessagesServiceDidFinishRefreshingMessages(messages) }
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: messages) })
    }

    private(set) var unreadCount: Int = 0
    func notifyUnreadCountDidChange(to count: Int) {
        unreadCount = count
        observers.forEach { $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) }
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) })
    }

}
