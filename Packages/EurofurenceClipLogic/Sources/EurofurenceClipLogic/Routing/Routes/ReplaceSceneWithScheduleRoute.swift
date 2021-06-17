import ComponentBase
import ScheduleComponent

public struct ReplaceSceneWithScheduleRoute {
    
    private let scene: ClipContentScene
    
    public init(scene: ClipContentScene) {
        self.scene = scene
    }
    
}

extension ReplaceSceneWithScheduleRoute: ContentRoute {
    
    public typealias Content = ScheduleContentRepresentation
    
    public func route(_ content: ScheduleContentRepresentation) {
        scene.prepareForShowingEvents()
    }
    
}
