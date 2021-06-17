import ComponentBase
import DealersComponent

public struct ReplaceSceneWithDealersRoute {
    
    private let scene: ClipContentScene
    
    public init(scene: ClipContentScene) {
        self.scene = scene
    }
    
}

// MARK: - ReplaceSceneWithDealersRoute + ContentRoute

extension ReplaceSceneWithDealersRoute: ContentRoute {
    
    public typealias Content = DealersContentRepresentation
    
    public func route(_ content: DealersContentRepresentation) {
        scene.prepareForShowingDealers()
    }
    
}
