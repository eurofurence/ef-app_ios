import Foundation
import RouterCore

public struct WebRouteable: Routeable {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
}
