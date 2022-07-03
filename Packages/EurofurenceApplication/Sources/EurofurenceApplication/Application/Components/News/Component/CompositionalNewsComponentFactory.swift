import EurofurenceModel
import RouterCore
import UIKit

struct CompositionalNewsComponentFactory: NewsComponentFactory {
    
    let sceneFactory: any CompositionalNewsSceneFactory
    let widgets: [any NewsWidget]
    let refreshService: any RefreshService
    
    func makeNewsComponent(_ delegate: any NewsComponentDelegate) -> UIViewController {
        let newsScene = sceneFactory.makeCompositionalNewsScene()
        let delegateAdapter = CompositionalNewsRoutesToDelegate(delegate: delegate)
        let environment = Environment(newsScene: newsScene, router: delegateAdapter)
        let delegate = InstallWidgetsOnSceneReady(
            scene: newsScene,
            environment: environment,
            widgets: widgets,
            refreshService: refreshService
        )
        
        refreshService.add(delegate)
        newsScene.setDelegate(delegate)
        
        return newsScene
    }
    
    private struct Environment: NewsWidgetEnvironment {
        
        let newsScene: CompositionalNewsScene
        
        let router: Router
        
        func install(dataSource: TableViewMediator) {
            newsScene.install(dataSource: dataSource)
        }
        
    }
    
    private struct InstallWidgetsOnSceneReady: CompositionalNewsSceneDelegate, RefreshServiceObserver {
        
        unowned let scene: any CompositionalNewsScene
        let environment: any NewsWidgetEnvironment
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
        
    }
    
}
