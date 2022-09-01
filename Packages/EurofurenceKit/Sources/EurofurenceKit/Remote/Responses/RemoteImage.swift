import Foundation.NSDate

struct RemoteImage: RemoteEntity {
    
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
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var internalReference: String
    var width: Int
    var height: Int
    var sizeInBytes: Int
    var mimeType: String
    var contentHashSha1: String
    
}
