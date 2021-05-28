import DealersComponent
import Foundation

// MARK: - ExpressibleByURL

extension DealersContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.absoluteString.lowercased().contains("/dealers") else { return nil }
        self.init()
    }
    
}
