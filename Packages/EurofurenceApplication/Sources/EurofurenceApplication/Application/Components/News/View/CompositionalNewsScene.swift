public protocol CompositionalNewsScene {
    
    func setDelegate(_ delegate: CompositionalNewsSceneDelegate)
    func install(dataSource: TableViewMediator)
    
}

public protocol CompositionalNewsSceneDelegate {
    
    func sceneReady()
    
}
