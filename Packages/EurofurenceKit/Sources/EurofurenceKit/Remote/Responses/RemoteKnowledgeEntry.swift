import Foundation.NSDate

struct RemoteKnowledgeEntry: RemoteEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case knowledgeGroupIdentifier = "KnowledgeGroupId"
        case title = "Title"
        case text = "Text"
        case order = "Order"
        case links = "Links"
        case imageIdentifiers = "ImageIds"
    }
    
    var lastChangeDateTimeUtc: Date
    var id: String
    var knowledgeGroupIdentifier: String
    var title: String
    var text: String
    var order: Int
    var links: [RemoteLink]
    var imageIdentifiers: [String]
    
}
