import EurofurenceModel
import Foundation

struct FakeShareableURLFactory: ShareableURLFactory {
    
    func makeURL(for eventIdentifier: EventIdentifier) -> URL {
        return unwrap(URL(string: "event://\(eventIdentifier.rawValue)"))
    }
    
}
