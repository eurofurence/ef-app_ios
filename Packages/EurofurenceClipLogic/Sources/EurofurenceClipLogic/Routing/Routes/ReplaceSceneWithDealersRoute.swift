import DealersComponent
import RouterCore

public struct ReplaceSceneWithDealersRoute {
    
    private let scene: ClipContentScene
    
    public init(scene: ClipContentScene) {
        self.scene = scene
    }
    
}

// MARK: - ReplaceSceneWithDealersRoute + Route

extension ReplaceSceneWithDealersRoute: Route {
    
    public typealias Parameter = DealersRouteable
    
    public func route(_ content: DealersRouteable) {
        scene.prepareForShowingDealers()
    }
    
}
