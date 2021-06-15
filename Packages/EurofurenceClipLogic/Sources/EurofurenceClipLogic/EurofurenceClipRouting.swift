import ComponentBase

public struct EurofurenceClipRouting {
    
    private let router: ContentRouter
    private let fallbackContent: ClipFallbackContent
    
    public init(router: ContentRouter, fallbackContent: ClipFallbackContent) {
        self.router = router
        self.fallbackContent = fallbackContent
    }
    
    public func route<Content>(_ content: Content) where Content: ContentRepresentation {
        do {
            try router.route(content)
        } catch {
            fallbackContent.presentFallbackContent()
        }
    }
    
}
