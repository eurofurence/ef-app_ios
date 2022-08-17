public protocol CompositionalNewsScene: AnyObject {
    
    func setDelegate(_ delegate: CompositionalNewsSceneDelegate)
    func install(dataSource: TableViewMediator)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}

public protocol CompositionalNewsSceneDelegate {
    
    func sceneReady()
    func reloadRequested()
    func settingsTapped(sender: Any)
    
}
