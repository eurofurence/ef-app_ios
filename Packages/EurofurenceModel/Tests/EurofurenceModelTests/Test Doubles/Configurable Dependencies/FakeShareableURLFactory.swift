import EurofurenceModel
import Foundation

struct FakeShareableURLFactory: ShareableURLFactory {
    
    func makeURL(for eventIdentifier: EventIdentifier) -> URL {
        return URL(string: "event://\(eventIdentifier.rawValue)").unsafelyUnwrapped
    }
    
    func makeURL(for dealerIdentifier: DealerIdentifier) -> URL {
        return URL(string: "dealer://\(dealerIdentifier.rawValue)").unsafelyUnwrapped
    }
    
    func makeURL(for knowledgeEntryIdentifier: KnowledgeEntryIdentifier) -> URL {
        return URL(string: "knowledgeentry://\(knowledgeEntryIdentifier.rawValue)").unsafelyUnwrapped
    }
    
}
