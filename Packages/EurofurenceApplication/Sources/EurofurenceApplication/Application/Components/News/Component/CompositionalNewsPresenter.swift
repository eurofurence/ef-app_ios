import EurofurenceModel

struct CompositionalNewsPresenter: CompositionalNewsSceneDelegate, RefreshServiceObserver {
    
    unowned let scene: any CompositionalNewsScene
    let environment: NewsRoutingEnvironment
    let widgets: [any NewsWidget]
    let refreshService: any RefreshService
    
    func sceneReady() {
        for widget in widgets {
            widget.register(in: environment)
        }
    }
    
    func reloadRequested() {
        refreshService.refreshLocalStore(completionHandler: { (_) in })
    }
    
    func refreshServiceDidBeginRefreshing() {
        scene.showLoadingIndicator()
    }
    
    func refreshServiceDidFinishRefreshing() {
        scene.hideLoadingIndicator()
    }
    
    func settingsTapped(sender: Any) {
        environment.delegate.newsModuleDidRequestShowingSettings(sender: sender)
    }
    
}
