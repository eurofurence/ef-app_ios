import Foundation.NSDate

public struct KnowledgeGroup: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case description = "Description"
        case order = "Order"
        case fontAwesomeIconCharacterUnicodeAddress = "FontAwesomeIconCharacterUnicodeAddress"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var name: String
    public var description: String
    public var order: Int
    public var fontAwesomeIconCharacterUnicodeAddress: String
    
}
