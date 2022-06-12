import EurofurenceModel

public struct ContentSceneController {
    
    public init(sessionState: SessionStateService, scene: ContentBootstrappingScene) {
        sessionState.add(observer: UpdateSceneWhenStateChanges(scene: scene))
    }
    
    private struct UpdateSceneWhenStateChanges: SessionStateObserver {
        
        var scene: ContentBootstrappingScene
        
        func sessionStateDidChange(_ newState: EurofurenceSessionState) {
            switch newState {
            case .uninitialized:
                scene.showTutorial()
                
            case .stale:
                scene.showPreloading()
                
            case .initialized:
                scene.showContent()
            }
        }
        
    }
    
}
