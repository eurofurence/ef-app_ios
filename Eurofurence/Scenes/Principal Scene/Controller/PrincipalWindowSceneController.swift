import EurofurenceModel

public struct PrincipalWindowSceneController {
    
    public init(sessionState: SessionStateService, scene: PrincipalWindowScene) {
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
