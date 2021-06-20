import EurofurenceModel
import EventDetailComponent
import RouterCore
import URLRouteable

struct EventDeepLink {
    
    var identifier: EventIdentifier
    
}

// MARK: - EventDeepLink + Decodable

extension EventDeepLink: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "Events"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(EventIdentifier.self, forKey: .identifier)
    }
    
}

// MARK: - EventDeepLink + Routeable

extension EventDeepLink: Routeable { }

// MARK: - EventDeepLink + YieldsRouteable

extension EventDeepLink: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(EventRouteable(identifier: identifier))
    }
    
}
