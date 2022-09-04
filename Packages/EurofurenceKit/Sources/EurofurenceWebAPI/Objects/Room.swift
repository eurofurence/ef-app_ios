import Foundation.NSDate

public struct Room: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case shortName = "ShortName"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var name: String
    public var shortName: String
    
}
