import EurofurenceModel
import TestUtilities

public final class StubMessage: Message {

    public var identifier: String
    public var authorName: String
    public var receivedDateTime: Date
    public var subject: String
    public var contents: String
    public var isRead: Bool

    public init(identifier: String,
                authorName: String,
                receivedDateTime: Date,
                subject: String,
                contents: String,
                isRead: Bool) {
        self.identifier = identifier
        self.authorName = authorName
        self.receivedDateTime = receivedDateTime
        self.subject = subject
        self.contents = contents
        self.isRead = isRead
    }
    
    public private(set) var markedRead = false
    public func markAsRead() {
        markedRead = true
    }

}

extension StubMessage: RandomValueProviding {

    public static var random: StubMessage {
        return StubMessage(identifier: .random,
                           authorName: .random,
                           receivedDateTime: .random,
                           subject: .random,
                           contents: .random,
                           isRead: .random)
    }

}
