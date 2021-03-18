import EurofurenceModel

public struct ContentSceneController {
    
    public init(sessionState: SessionStateService, scene: ContentBootstrappingScene) {
        sessionState.determineSessionState(completionHandler: { (state) in
            switch state {
            case .uninitialized:
                scene.showTutorial()
                
            case .stale:
                scene.showPreloading()
                
            case .initialized:
                scene.showContent()
            }
        })
    }
    
}
