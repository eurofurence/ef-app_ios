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

class CapturingPrivateMessagesService: PrivateMessagesService {

    private var privateMessageObservers = [PrivateMessagesObserver]()
    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }

    var unreadMessageCount: Int = 0
    var localMessages: [MessageCharacteristics] = []

    init(unreadMessageCount: Int = 0, localMessages: [MessageCharacteristics] = []) {
        self.localMessages = localMessages
    }

    private(set) var wasToldToRefreshMessages = false
    private(set) var refreshMessagesCount = 0
    func refreshMessages() {
        wasToldToRefreshMessages = true
        refreshMessagesCount += 1
    }

    private(set) var messageMarkedAsRead: MessageCharacteristics?
    func markMessageAsRead(_ message: MessageCharacteristics) {
        messageMarkedAsRead = message
    }

    func failLastRefresh() {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
    }

    func succeedLastRefresh(messages: [MessageCharacteristics] = []) {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: messages) })
    }

    private(set) var unreadCount: Int = 0
    func notifyUnreadCountDidChange(to count: Int) {
        unreadCount = count
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) })
    }

}
