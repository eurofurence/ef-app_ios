import Foundation.NSDate

public struct Announcement: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case validFromDateTimeUtc = "ValidFromDateTimeUtc"
        case validUntilDateTimeUtc = "ValidUntilDateTimeUtc"
        case area = "Area"
        case author = "Author"
        case title = "Title"
        case content = "Content"
        case imageIdentifier = "ImageId"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var validFromDateTimeUtc: Date
    public var validUntilDateTimeUtc: Date
    public var area: String
    public var author: String
    public var title: String
    public var content: String
    public var imageIdentifier: String?
    
}
