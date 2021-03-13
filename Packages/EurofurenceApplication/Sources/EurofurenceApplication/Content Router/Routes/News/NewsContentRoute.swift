import Foundation

public struct NewsContentRoute {
    
    private let newsPresentation: NewsPresentation
    
    public init(newsPresentation: NewsPresentation) {
        self.newsPresentation = newsPresentation
    }
    
}

// MARK: - ContentRoute

extension NewsContentRoute: ContentRoute {
    
    public typealias Content = NewsContentRepresentation
    
    public func route(_ content: NewsContentRepresentation) {
        newsPresentation.showNews()
    }
    
}
