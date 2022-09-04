import Foundation.NSDate

public struct Track: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var name: String
    
}
