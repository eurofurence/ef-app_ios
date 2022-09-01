import Foundation.NSDate

struct RemoteKnowledgeGroup: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case name = "Name"
        case description = "Description"
        case order = "Order"
        case fontAwesomeIconCharacterUnicodeAddress = "FontAwesomeIconCharacterUnicodeAddress"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var name: String
    var description: String
    var order: Int
    var fontAwesomeIconCharacterUnicodeAddress: String
    
}
