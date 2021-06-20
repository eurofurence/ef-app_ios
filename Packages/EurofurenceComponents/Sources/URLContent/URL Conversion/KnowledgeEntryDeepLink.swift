import EurofurenceModel
import KnowledgeDetailComponent
import RouterCore
import URLRouteable

struct KnowledgeEntryDeepLink {
    
    var identifier: KnowledgeEntryIdentifier
    
}

// MARK: - KnowledgeEntryDeepLink + Decodable

extension KnowledgeEntryDeepLink: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "KnowledgeEntries"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(KnowledgeEntryIdentifier.self, forKey: .identifier)
    }
    
}

// MARK: - KnowledgeEntryDeepLink + Routeable

extension KnowledgeEntryDeepLink: Routeable { }

// MARK: - KnowledgeEntryDeepLink + YieldsRouteable

extension KnowledgeEntryDeepLink: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(KnowledgeEntryRouteable(identifier: identifier))
    }
    
}
