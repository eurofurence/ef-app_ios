import Foundation

public typealias MessageIdentifier = Identifier<Message>

public protocol Message {

    var identifier: MessageIdentifier { get }
    var authorName: String { get }
    var receivedDateTime: Date { get }
    var subject: String { get }
    var contents: String { get }
    
    func add(_ observer: PrivateMessageObserver)
    
    func markAsRead()

}

public protocol PrivateMessageObserver {
    
    func messageMarkedUnread()
    func messageMarkedRead()
    
}
