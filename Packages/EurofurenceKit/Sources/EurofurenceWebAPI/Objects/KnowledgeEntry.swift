import Foundation.NSDate

public struct KnowledgeEntry: APIEntity {
    
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
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var knowledgeGroupIdentifier: String
    public var title: String
    public var text: String
    public var order: Int
    public var links: [Link]
    public var imageIdentifiers: [String]
    
}
