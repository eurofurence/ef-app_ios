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
        return baseURL.appendingPathComponent("Events/\(eventIdentifier.rawValue)")
    }
    
    func makeURL(for dealerIdentifier: DealerIdentifier) -> URL {
        return baseURL.appendingPathComponent("Dealers/\(dealerIdentifier.rawValue)")
    }
    
}
