import ComponentBase
import DealerComponent
import EventDetailComponent

public struct EurofurenceClipRouting {
    
    private let router: ContentRouter
    private let clipScene: ClipContentScene
    
    public init(router: ContentRouter, clipScene: ClipContentScene) {
        self.router = router
        self.clipScene = clipScene
        
        clipScene.prepareForShowingEvents()
    }
    
    public func route<Content>(_ content: Content) where Content: ContentRepresentation {
        switch content {
        case is DealerContentRepresentation:
            clipScene.prepareForShowingDealers()
            
        case is EventContentRepresentation:
            clipScene.prepareForShowingEvents()
            
        default:
            clipScene.prepareForShowingEvents()
            return
        }
        
        try? router.route(content)
    }
    
}
