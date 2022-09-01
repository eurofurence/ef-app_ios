import Foundation.NSDate

struct RemoteRoom: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case shortName = "ShortName"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    var shortName: String
    
}
