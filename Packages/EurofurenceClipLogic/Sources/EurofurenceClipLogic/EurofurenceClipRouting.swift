import ComponentBase
import DealerComponent
import EventDetailComponent

public struct EurofurenceClipRouting {
    
    private let router: ContentRouter
    private let clipScene: ClipContentScene
    
    public init(router: ContentRouter, clipScene: ClipContentScene) {
        self.router = router
        self.clipScene = clipScene
    }
    
    public func route<Content>(_ content: Content) where Content: ContentRepresentation {
        do {
            switch content {
            case is EventContentRepresentation:
                clipScene.prepareForShowingEvents()
                
            case is DealerContentRepresentation:
                clipScene.prepareForShowingDealers()
                
            default:
                break
            }
            
            try router.route(content)
        } catch {
            clipScene.presentFallbackContent()
        }
    }
    
}
