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

    var wasToldSuccessfullyLoadedPrivateMessages = false
    private(set) var observedMessages: [APIMessage] = []
    func privateMessagesServiceDidFinishRefreshingMessages(messages: [APIMessage]) {
        observedMessages = messages
        self.wasToldSuccessfullyLoadedPrivateMessages = true
    }

    private(set) var observedUnreadMessageCount: Int?
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        observedUnreadMessageCount = unreadCount
    }

    private(set) var wasToldFailedToLoadPrivateMessages = false
    func privateMessagesServiceDidFailToLoadMessages() {
        wasToldFailedToLoadPrivateMessages = true
    }

    // MARK: Old

    private(set) var wasToldUserNotAuthenticated = false
    func completionHandler(_ result: PrivateMessageResult) {
        switch result {
        case .success(_):
            break

        case .userNotAuthenticated:
            self.wasToldUserNotAuthenticated = true

        case .failedToLoad:
            break
        }
    }

}
