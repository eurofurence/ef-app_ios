import EurofurenceModel
import Foundation

struct FakeShareableURLFactory: ShareableURLFactory {
    
    func makeURL(for eventIdentifier: EventIdentifier) -> URL {
        return unwrap(URL(string: "event://\(eventIdentifier.rawValue)"))
    }
    
    func makeURL(for dealerIdentifier: DealerIdentifier) -> URL {
        return unwrap(URL(string: "dealer://\(dealerIdentifier.rawValue)"))
    }
    
}
