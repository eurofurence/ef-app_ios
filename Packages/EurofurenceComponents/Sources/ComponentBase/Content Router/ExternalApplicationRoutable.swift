import Foundation
import RouterCore

public struct ExternalApplicationRouteable: Routeable {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
}
