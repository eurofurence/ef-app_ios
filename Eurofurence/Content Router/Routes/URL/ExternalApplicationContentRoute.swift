import EurofurenceModel

public struct ExternalApplicationContentRoute {
    
    private let urlOpener: URLOpener
    
    public init(urlOpener: URLOpener) {
        self.urlOpener = urlOpener
    }
    
}

// MARK: - ContentRoute

extension ExternalApplicationContentRoute: ContentRoute {
    
    public typealias Content = ExternalApplicationContentRepresentation
    
    public func route(_ content: ExternalApplicationContentRepresentation) {
        urlOpener.open(content.url)
    }
    
}
