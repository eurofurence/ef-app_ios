import ComponentBase
import DealerComponent
import EventDetailComponent

public struct EurofurenceClipRouting {
    
    private let router: ContentRouter
    private let scenePreparer: PrepareSceneForKnownContentTypes
    
    public init(router: ContentRouter, clipScene: ClipContentScene) {
        self.router = router
        self.scenePreparer = PrepareSceneForKnownContentTypes(clipScene: clipScene)
        
        clipScene.prepareForShowingEvents()
    }
    
    public func route<Content>(_ content: Content) where Content: ContentRepresentation {
        scenePreparer.receive(content)
        try? router.route(content)
    }
    
    private struct PrepareSceneForKnownContentTypes: ContentRepresentationRecipient {
        
        var clipScene: ClipContentScene
        
        func receive<Content>(_ content: Content) where Content: ContentRepresentation {
            if let describing = content as? ContentRepresentationDescribing {
                describing.describe(to: self)
            } else {
                switch content {
                case is DealerContentRepresentation:
                    clipScene.prepareForShowingDealers()
                    
                case is EventContentRepresentation:
                    clipScene.prepareForShowingEvents()
                    
                default:
                    clipScene.prepareForShowingEvents()
                }
            }
        }
        
    }
    
}
