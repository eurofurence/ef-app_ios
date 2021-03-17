import ComponentBase
import Foundation

public struct WebContentRepresentation: ContentRepresentation {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
}
