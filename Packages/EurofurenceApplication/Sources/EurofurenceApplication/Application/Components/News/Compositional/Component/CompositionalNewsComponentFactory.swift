import RouterCore
import UIKit

struct CompositionalNewsComponentFactory: NewsComponentFactory {
    
    let sceneFactory: any CompositionalNewsSceneFactory
    let widgets: [any NewsWidget]
    
    func makeNewsComponent(_ delegate: any NewsComponentDelegate) -> UIViewController {
        let newsScene = sceneFactory.makeCompositionalNewsScene()
        let delegateAdapter = CompositionalNewsRoutesToDelegate(delegate: delegate)
        let environment = Environment(newsScene: newsScene, router: delegateAdapter)
        newsScene.setDelegate(InstallWidgetsOnSceneReady(environment: environment, widgets: widgets))
        
        return newsScene
    }
    
    private struct Environment: NewsWidgetEnvironment {
        
        let newsScene: CompositionalNewsScene
        
        let router: Router
        
        func install(dataSource: TableViewMediator) {
            newsScene.install(dataSource: dataSource)
        }
        
    }
    
    private struct InstallWidgetsOnSceneReady: CompositionalNewsSceneDelegate {
        
        let environment: any NewsWidgetEnvironment
        let widgets: [any NewsWidget]
        
        func sceneReady() {
            for widget in widgets {
                widget.register(in: environment)
            }
        }
        
    }
    
}
