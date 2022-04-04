import UIKit

struct CompositionalNewsComponentFactory: NewsComponentFactory {
    
    let sceneFactory: any CompositionalNewsSceneFactory
    let widgets: [any NewsWidget]
    
    func makeNewsComponent(_ delegate: any NewsComponentDelegate) -> UIViewController {
        let compositionalNewsScene = sceneFactory.makeCompositionalNewsScene()
        
        for widget in widgets {
            widget.register(in: compositionalNewsScene)
        }
        
        return compositionalNewsScene
    }
    
}
