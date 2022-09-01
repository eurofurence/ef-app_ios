import Foundation.NSDate

struct RemoteTrack: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    
}
