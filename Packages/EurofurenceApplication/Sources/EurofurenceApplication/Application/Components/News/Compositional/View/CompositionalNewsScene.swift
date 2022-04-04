public protocol CompositionalNewsScene: NewsWidgetManager {
    
    func setDelegate(_ delegate: CompositionalNewsSceneDelegate)
    
}

public protocol CompositionalNewsSceneDelegate {
    
    func sceneReady()
    
}
