import EurofurenceModel
import UIKit

struct MessageDetail2ModuleProviding: MessageDetailModuleProviding {
    
    var sceneFactory: MessageDetailSceneFactory
    var messagesService: PrivateMessagesService
    
    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController {
        let scene = sceneFactory.makeMessageDetailScene()
        
        _ = MessageDetailPresenter2(message: message, scene: scene, messagesService: messagesService)
        
        return UIViewController()
    }
    
}

struct MessageDetailPresenter2: MessageDetailSceneDelegate {
    
    private let message: MessageIdentifier
    private let scene: MessageDetailScene
    private let messagesService: PrivateMessagesService
    
    init(message: MessageIdentifier, scene: MessageDetailScene, messagesService: PrivateMessagesService) {
        self.message = message
        self.scene = scene
        self.messagesService = messagesService
        
        scene.delegate = self
    }
    
    func messageDetailSceneDidLoad() {
        scene.showLoadingIndicator()
        
        messagesService.fetchMessage(identifiedBy: message) { (_) in
            self.scene.hideLoadingIndicator()
        }
    }
    
}
