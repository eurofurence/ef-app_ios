import Foundation

public protocol Message {

    var identifier: String { get }
    var authorName: String { get }
    var receivedDateTime: Date { get }
    var subject: String { get }
    var contents: String { get }
    var isRead: Bool { get }
    
    func markAsRead()

}
