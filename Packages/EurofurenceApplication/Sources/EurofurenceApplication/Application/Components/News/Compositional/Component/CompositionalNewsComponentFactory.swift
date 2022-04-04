import UIKit

struct CompositionalNewsComponentFactory: NewsComponentFactory {
    
    let sceneFactory: any CompositionalNewsSceneFactory
    let widgets: [any NewsWidget]
    
    func makeNewsComponent(_ delegate: any NewsComponentDelegate) -> UIViewController {
        let newsScene = sceneFactory.makeCompositionalNewsScene()
        newsScene.setDelegate(InstallWidgetsOnSceneReady(manager: newsScene, widgets: widgets))
        
        return newsScene
    }
    
    private struct InstallWidgetsOnSceneReady: CompositionalNewsSceneDelegate {
        
        unowned let manager: any NewsWidgetManager
        let widgets: [any NewsWidget]
        
        func sceneReady() {
            for widget in widgets {
                widget.register(in: manager)
            }
        }
        
    }
    
}
