import Foundation

public struct Message: Decodable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case author = "AuthorName"
        case subject = "Subject"
        case message = "Message"
        case receivedDate = "ReceivedDateTimeUtc"
        case readDate = "ReadDateTimeUtc"
    }
    
    public var id: String
    public var author: String
    public var subject: String
    public var message: String
    public var receivedDate: Date
    public var readDate: Date?
    
    public init(
        id: String,
        author: String,
        subject: String,
        message: String,
        receivedDate: Date,
        readDate: Date?
    ) {
        self.id = id
        self.author = author
        self.subject = subject
        self.message = message
        self.receivedDate = receivedDate
        self.readDate = readDate
    }
    
}
