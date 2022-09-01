import Foundation.NSDate

public struct RemoteRoom: RemoteEntity {
    
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
