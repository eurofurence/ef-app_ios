import RouterCore
import ScheduleComponent

public struct ReplaceSceneWithScheduleRoute {
    
    private let scene: ClipContentScene
    
    public init(scene: ClipContentScene) {
        self.scene = scene
    }
    
}

// MARK: - ReplaceSceneWithScheduleRoute + ContentRoute

extension ReplaceSceneWithScheduleRoute: Route {
    
    public typealias Parameter = ScheduleRouteable
    
    public func route(_ content: ScheduleRouteable) {
        scene.prepareForShowingEvents()
    }
    
}
