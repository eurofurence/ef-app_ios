import DealerComponent
import EurofurenceModel
import RouterCore
import URLRouteable

struct DealerDeepLink {
    
    var identifier: DealerIdentifier
    
}

// MARK: - DealerDeepLink + Decodable

extension DealerDeepLink: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "Dealers"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(DealerIdentifier.self, forKey: .identifier)
    }
    
}

// MARK: - DealerDeepLink + Routeable

extension DealerDeepLink: Routeable { }

// MARK: - DealerDeepLink + YieldsRouteable

extension DealerDeepLink: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(DealerRouteable(identifier: identifier))
    }
    
}
