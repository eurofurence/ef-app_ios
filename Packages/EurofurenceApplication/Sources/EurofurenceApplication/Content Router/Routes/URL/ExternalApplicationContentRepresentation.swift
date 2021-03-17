import ComponentBase
import Foundation

public struct ExternalApplicationContentRepresentation: ContentRepresentation {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
}
