import Foundation

public struct MessageCharacteristics: Identifyable {

    public var identifier: String
    
    public var authorName: String
    public var receivedDateTime: Date
    public var subject: String
    public var contents: String
    public var isRead: Bool

    public init(
        identifier: String, 
        authorName: String,
        receivedDateTime: Date,
        subject: String, 
        contents: String, 
        isRead: Bool
    ) {
        self.identifier = identifier
        self.authorName = authorName
        self.receivedDateTime = receivedDateTime
        self.subject = subject
        self.contents = contents
        self.isRead = isRead
    }

}
