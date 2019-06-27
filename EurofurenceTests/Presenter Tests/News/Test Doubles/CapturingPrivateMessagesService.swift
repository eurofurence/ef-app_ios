@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingPrivateMessagesService: PrivateMessagesService {

    private var privateMessageObservers = [PrivateMessagesObserver]()
    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }
    
    func fetchMessage(identifiedBy identifier: MessageIdentifier) -> Message? {
        return nil
    }

    var unreadMessageCount: Int = 0
    var localMessages: [Message] = []

    init(unreadMessageCount: Int = 0, localMessages: [Message] = []) {
        self.localMessages = localMessages
    }

    private(set) var wasToldToRefreshMessages = false
    private(set) var refreshMessagesCount = 0
    func refreshMessages() {
        wasToldToRefreshMessages = true
        refreshMessagesCount += 1
    }

    func failLastRefresh() {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
    }

    func succeedLastRefresh(messages: [Message] = []) {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: messages) })
    }

    private(set) var unreadCount: Int = 0
    func notifyUnreadCountDidChange(to count: Int) {
        unreadCount = count
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) })
    }

}
