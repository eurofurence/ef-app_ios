import Foundation.NSDate

public struct Day: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case date = "Date"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var name: String
    public var date: Date
    
}
