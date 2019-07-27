import Foundation

public protocol PrivateMessagesService {

    func add(_ observer: PrivateMessagesObserver)
    func refreshMessages()
    func fetchMessage(identifiedBy identifier: MessageIdentifier) -> Message?

}

public protocol PrivateMessagesObserver {

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message])
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFailToLoadMessages()

}
