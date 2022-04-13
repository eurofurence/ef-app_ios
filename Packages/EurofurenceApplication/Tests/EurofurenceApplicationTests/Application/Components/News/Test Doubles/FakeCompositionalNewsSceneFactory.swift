import EurofurenceApplication
import UIKit

class FakeCompositionalNewsSceneFactory: CompositionalNewsSceneFactory {
    
    let scene = FakeCompositionalNewsScene()
    func makeCompositionalNewsScene() -> UIViewController & CompositionalNewsScene {
        scene
    }
    
}

class FakeCompositionalNewsScene: UIViewController, CompositionalNewsScene {
    
    private(set) var installedDataSources = [TableViewMediator]()
    private var delegate: CompositionalNewsSceneDelegate?
    
    func setDelegate(_ delegate: CompositionalNewsSceneDelegate) {
        self.delegate = delegate
    }
    
    func install(dataSource: TableViewMediator) {
        installedDataSources.append(dataSource)
    }
    
    func simulateSceneReady() {
        delegate?.sceneReady()
    }
    
}
