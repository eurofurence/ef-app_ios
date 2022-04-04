import UIKit

struct CompositionalNewsComponentFactory: NewsComponentFactory {
    
    let sceneFactory: CompositionalNewsSceneFactory
    
    func makeNewsComponent(_ delegate: NewsComponentDelegate) -> UIViewController {
        sceneFactory.makeCompositionalNewsScene()
    }
    
}
