import Foundation

public protocol PrivateMessagesService {

    func add(_ observer: PrivateMessagesObserver)
    
    func refreshMessages()
    
    func fetchMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, Error>) -> Void
    )

}

public enum PrivateMessageError: Error, LocalizedError {
    
    case loadingMessagesFailed
    case noMessageFound
    
    public var localizedDescription: String {
        switch self {
        case .loadingMessagesFailed:
            return NSLocalizedString(
                "Loading Messages Failed Error Description",
                bundle: .eurofurenceModel,
                comment: "Error description when unable to load private messages due to network conditions"
            )
            
        case .noMessageFound:
            return NSLocalizedString(
                "No Message Found Error Description",
                bundle: .eurofurenceModel,
                comment: "Error description when unable to find a specific private message"
            )
        }
    }
    
}

public protocol PrivateMessagesObserver {

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message])
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFailToLoadMessages()

}
