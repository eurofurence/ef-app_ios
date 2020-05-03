import EurofurenceModel

public struct PrincipalWindowSceneController: SessionStateServiceObserver {
    
    private let scene: PrincipalWindowScene
    
    public init(sessionState: SessionStateService, scene: PrincipalWindowScene) {
        self.scene = scene
        sessionState.add(self)
    }
    
    public func modelDidEnterUninitializedState() {
        scene.showTutorial()
    }
    
    public func modelDidEnterStaleState() {
        scene.showPreloading()
    }
    
    public func modelDidEnterInitializedState() {
        scene.showContent()
    }
    
}
