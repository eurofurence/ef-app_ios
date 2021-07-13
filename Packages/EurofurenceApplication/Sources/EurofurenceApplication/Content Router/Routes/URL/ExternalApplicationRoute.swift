import ComponentBase
import EurofurenceModel
import RouterCore

public struct ExternalApplicationRoute {
    
    private let urlOpener: URLOpener
    
    public init(urlOpener: URLOpener) {
        self.urlOpener = urlOpener
    }
    
}

// MARK: - Route

extension ExternalApplicationRoute: Route {
    
    public typealias Parameter = ExternalApplicationRouteable
    
    public func route(_ content: ExternalApplicationRouteable) {
        urlOpener.open(content.url)
    }
    
}
