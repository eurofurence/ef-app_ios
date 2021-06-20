import DealerComponent
import EventDetailComponent
import RouterCore

public struct EurofurenceClipRouting {
    
    private let router: Router
    private let scenePreparer: PrepareSceneForKnownContentTypes
    
    public init(router: Router, clipScene: ClipContentScene) {
        self.router = router
        self.scenePreparer = PrepareSceneForKnownContentTypes(clipScene: clipScene)
        
        clipScene.prepareForShowingEvents()
    }
    
    public func route<Content>(_ content: Content) where Content: Routeable {
        scenePreparer.receive(content)
        try? router.route(content)
    }
    
    private struct PrepareSceneForKnownContentTypes: YieldedRouteableRecipient {
        
        var clipScene: ClipContentScene
        
        func receive<Content>(_ content: Content) where Content: Routeable {
            if let describing = content as? YieldsRoutable {
                describing.yield(to: self)
            } else {
                switch content {
                case is DealerRouteable:
                    clipScene.prepareForShowingDealers()
                    
                case is EventRouteable:
                    clipScene.prepareForShowingEvents()
                    
                default:
                    clipScene.prepareForShowingEvents()
                }
            }
        }
        
    }
    
}
