import EurofurenceModel
import Foundation

class CapturingPrivateMessagesObserver: PrivateMessagesObserver {

    // MARK: New

    var wasToldSuccessfullyLoadedPrivateMessages = false
    private(set) var observedMessages: [Message] = []
    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message]) {
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

}
