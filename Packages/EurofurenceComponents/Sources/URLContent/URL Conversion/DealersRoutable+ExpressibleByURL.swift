import DealersComponent
import Foundation
import URLRouteable

extension DealersRouteable: ExpressibleByURL {
    
    public init?(url: URL) {
        guard url.absoluteString.lowercased().contains("/dealers") else { return nil }
        self.init()
    }
    
}
