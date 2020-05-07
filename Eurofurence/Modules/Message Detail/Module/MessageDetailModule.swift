import EurofurenceModel
import UIKit

struct MessageDetailModule: MessageDetailModuleProviding {
    
    var sceneFactory: MessageDetailSceneFactory
    var messagesService: PrivateMessagesService
    
    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController {
        let scene = sceneFactory.makeMessageDetailScene()
        
        _ = MessageDetailPresenter(message: message, scene: scene, messagesService: messagesService)
        
        return scene
    }
    
}
