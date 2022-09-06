import Foundation

public struct Message: Equatable {
    
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
