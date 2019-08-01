import EurofurenceModel
import Foundation
import TestUtilities

public final class FakeKnowledgeGroup: KnowledgeGroup {
    
    public var identifier: KnowledgeGroupIdentifier
    public var title: String
    public var groupDescription: String
    public var fontAwesomeCharacterAddress: Character
    public var order: Int
    public var entries: [KnowledgeEntry]

    public init(
        identifier: KnowledgeGroupIdentifier,
        title: String,
        groupDescription: String,
        fontAwesomeCharacterAddress: Character,
        order: Int,
        entries: [KnowledgeEntry]
    ) {
        self.identifier = identifier
        self.title = title
        self.groupDescription = groupDescription
        self.fontAwesomeCharacterAddress = fontAwesomeCharacterAddress
        self.order = order
        self.entries = entries
    }
    
}

extension FakeKnowledgeGroup: RandomValueProviding {

    public static var random: FakeKnowledgeGroup {
        return FakeKnowledgeGroup(identifier: .random,
                                  title: .random,
                                  groupDescription: .random,
                                  fontAwesomeCharacterAddress: .random,
                                  order: .random,
                                  entries: .random)
    }

}
