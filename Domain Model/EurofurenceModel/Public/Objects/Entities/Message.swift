import Foundation

public typealias MessageIdentifier = Identifier<Message>

public protocol Message {

    var identifier: MessageIdentifier { get }
    var authorName: String { get }
    var receivedDateTime: Date { get }
    var subject: String { get }
    var contents: String { get }
    var isRead: Bool { get }
    
    func markAsRead()

}
