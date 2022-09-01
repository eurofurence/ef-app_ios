import Foundation.NSDate

struct RemoteDay: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case date = "Date"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    var date: Date
    
}
