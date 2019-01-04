//
//  CapturingPrivateMessagesObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingPrivateMessagesObserver: PrivateMessagesObserver {

    // MARK: New

    private(set) var observedMessages: [APIMessage] = []
    func privateMessagesServiceDidFinishRefreshingMessages(messages: [APIMessage]) {
        observedMessages = messages
    }

    private(set) var observedUnreadMessageCount: Int?
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        observedUnreadMessageCount = unreadCount
    }

    func privateMessagesServiceDidFailToLoadMessages() {

    }

    // MARK: Old

    private(set) var wasToldSuccessfullyLoadedPrivateMessages = false
    private(set) var capturedMessages: [APIMessage]?
    private(set) var wasToldFailedToLoadPrivateMessages = false
    private(set) var wasToldUserNotAuthenticated = false
    func completionHandler(_ result: PrivateMessageResult) {
        switch result {
        case .success(let messages):
            self.wasToldSuccessfullyLoadedPrivateMessages = true
            self.capturedMessages = messages

        case .userNotAuthenticated:
            self.wasToldUserNotAuthenticated = true

        case .failedToLoad:
            self.wasToldFailedToLoadPrivateMessages = true
        }
    }

}
