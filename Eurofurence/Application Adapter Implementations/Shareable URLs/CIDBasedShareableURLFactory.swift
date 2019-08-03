import EurofurenceModel
import Foundation

struct CIDBasedShareableURLFactory: ShareableURLFactory {
    
    private let baseURL: URL
    
    init(conventionIdentifier: ConventionIdentifier) {
        let baseURLString = "https://app.eurofurence.org/\(conventionIdentifier.identifier)/Web"
        guard let baseURL = URL(string: baseURLString) else {
            fatalError("Unable to marshall the base URL from: \(baseURLString)")
        }
        
        self.baseURL = baseURL
    }
    
    func makeURL(for eventIdentifier: EventIdentifier) -> URL {
        return makeURL(appendingPathComponent: "Events/\(eventIdentifier.rawValue)")
    }
    
    func makeURL(for dealerIdentifier: DealerIdentifier) -> URL {
        return makeURL(appendingPathComponent: "Dealers/\(dealerIdentifier.rawValue)")
    }
    
    func makeURL(for knowledgeEntryIdentifier: KnowledgeEntryIdentifier) -> URL {
        return makeURL(appendingPathComponent: "KnowledgeEntries/\(knowledgeEntryIdentifier.rawValue)")
    }
    
    private func makeURL(appendingPathComponent pathComponent: String) -> URL {
        return baseURL.appendingPathComponent(pathComponent)
    }
    
}
