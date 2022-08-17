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
        let environment = NewsRoutingEnvironment(delegate: delegate, newsScene: newsScene, router: delegateAdapter)
        let presenter = CompositionalNewsPresenter(
            scene: newsScene,
            environment: environment,
            widgets: widgets,
            refreshService: refreshService
        )
        
        refreshService.add(presenter)
        newsScene.setDelegate(presenter)
        
        return newsScene
    }
    
}

struct NewsRoutingEnvironment: NewsWidgetEnvironment {
    
    let delegate: any NewsComponentDelegate
    let newsScene: CompositionalNewsScene
    let router: Router
    
    func install(dataSource: TableViewMediator) {
        newsScene.install(dataSource: dataSource)
    }
    
}
