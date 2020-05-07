import Foundation

public protocol PrivateMessagesService {

    func add(_ observer: PrivateMessagesObserver)
    
    func refreshMessages()
    
    func fetchMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, Error>) -> Void
    )

}

public enum PrivateMessageError: Error {
    
    case loadingMessagesFailed
    case noMessageFound
    
}

public protocol PrivateMessagesObserver {

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message])
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFailToLoadMessages()

}
