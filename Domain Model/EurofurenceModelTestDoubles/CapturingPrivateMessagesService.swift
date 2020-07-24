import EurofurenceModel

public class CapturingPrivateMessagesService: PrivateMessagesService {

    private var privateMessageObservers = [PrivateMessagesObserver]()
    public func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }
    
    public func fetchMessage(identifiedBy identifier: MessageIdentifier, completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void) {
        if let message = localMessages.first(where: { $0.identifier == identifier }) {
            completionHandler(.success(message))
        }
    }

    public var unreadMessageCount: Int = 0
    public var localMessages: [Message] = []

    public init(unreadMessageCount: Int = 0, localMessages: [Message] = []) {
        self.localMessages = localMessages
    }

    public private(set) var wasToldToRefreshMessages = false
    public private(set) var refreshMessagesCount = 0
    public func refreshMessages() {
        wasToldToRefreshMessages = true
        refreshMessagesCount += 1
    }
    
    public private(set) var removedObserver: Any?
    public func removeObserver(_ observer: PrivateMessagesObserver) {
        removedObserver = observer
    }

    public func failLastRefresh() {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFailToLoadMessages() })
    }

    public func succeedLastRefresh(messages: [Message] = []) {
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidFinishRefreshingMessages(messages: messages) })
    }

    public private(set) var unreadCount: Int = 0
    public func notifyUnreadCountDidChange(to count: Int) {
        unreadCount = count
        privateMessageObservers.forEach({ $0.privateMessagesServiceDidUpdateUnreadMessageCount(to: count) })
    }

}
