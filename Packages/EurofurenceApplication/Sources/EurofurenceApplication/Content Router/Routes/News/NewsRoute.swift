import RouterCore

public struct NewsRoute {
    
    private let newsPresentation: NewsPresentation
    
    public init(newsPresentation: NewsPresentation) {
        self.newsPresentation = newsPresentation
    }
    
}

// MARK: - Route

extension NewsRoute: Route {
    
    public typealias Parameter = NewsRouteable
    
    public func route(_ content: NewsRouteable) {
        newsPresentation.showNews()
    }
    
}
