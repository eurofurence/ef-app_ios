import ComponentBase
import Foundation

public struct DealersContentRepresentation: ContentRepresentation {
    
    public init() {
        
    }
    
}

// MARK: - ExpressibleByURL

extension DealersContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.absoluteString.lowercased().contains("/dealers") else { return nil }
    }
    
}
