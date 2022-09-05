import Foundation.NSDate

public struct Map: APIEntity {
    
    private enum CodingKeys: String, CodingKey {
        case lastChangeDateTimeUtc = "LastChangeDateTimeUtc"
        case id = "Id"
        case imageIdentifier = "ImageId"
        case description = "Description"
        case order = "Order"
        case isBrowseable = "IsBrowseable"
        case entries = "Entries"
    }
    
    public var lastChangeDateTimeUtc: Date
    public var id: String
    public var imageIdentifier: String
    public var description: String
    public var order: Int
    public var isBrowseable: Bool
    public var entries: [Map.Entry]
    
}

// MARK: - Entries

extension Map {
    
    public struct Entry: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case id = "Id"
            case x = "X"
            case y = "Y"
            case tapRadius = "TapRadius"
            case links = "Links"
        }
        
        public var id: String
        public var x: Int
        public var y: Int
        public var tapRadius: Int
        public var links: [Link]
        
    }
    
}
