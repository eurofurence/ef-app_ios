import EurofurenceModel
import UIKit

struct MessageDetail2ModuleProviding: MessageDetailModuleProviding {
    
    var sceneFactory: MessageDetailSceneFactory
    
    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController {
        let scene = sceneFactory.makeMessageDetailScene()
        
        _ = MessageDetailPresenter2(scene: scene)
        
        return UIViewController()
    }
    
}

struct MessageDetailPresenter2: MessageDetailSceneDelegate {
    
    private let scene: MessageDetailScene
    
    init(scene: MessageDetailScene) {
        self.scene = scene
        scene.delegate = self
    }
    
    func messageDetailSceneDidLoad() {
        scene.showLoadingIndicator()
    }
    
}
