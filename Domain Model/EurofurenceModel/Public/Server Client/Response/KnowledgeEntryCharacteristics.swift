import Foundation

public struct KnowledgeEntryCharacteristics: Comparable, Equatable, Identifyable {

    public var identifier: String
    
    public var groupIdentifier: String
    public var title: String
    public var order: Int
    public var text: String
    public var links: [LinkCharacteristics]
    public var imageIdentifiers: [String]

    public init(
        identifier: String,
        groupIdentifier: String,
        title: String,
        order: Int,
        text: String,
        links: [LinkCharacteristics],
        imageIdentifiers: [String]
    ) {
        self.identifier = identifier
        self.groupIdentifier = groupIdentifier
        self.title = title
        self.order = order
        self.text = text
        self.links = links
        self.imageIdentifiers = imageIdentifiers
    }

    public static func < (lhs: KnowledgeEntryCharacteristics, rhs: KnowledgeEntryCharacteristics) -> Bool {
        return lhs.title < rhs.title
    }

}
