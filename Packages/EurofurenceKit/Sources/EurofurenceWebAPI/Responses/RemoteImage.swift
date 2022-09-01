import Foundation.NSDate

public struct RemoteImage: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case internalReference = "InternalReference"
        case width = "Width"
        case height = "Height"
        case sizeInBytes = "SizeInBytes"
        case mimeType = "MimeType"
        case contentHashSha1 = "ContentHashSha1"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var internalReference: String
    public var width: Int
    public var height: Int
    public var sizeInBytes: Int
    public var mimeType: String
    public var contentHashSha1: String
    
}
