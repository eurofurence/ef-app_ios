import EurofurenceModel
import UIKit

struct MessageDetailComponentFactoryImpl: MessageDetailComponentFactory {
    
    var sceneFactory: MessageDetailSceneFactory
    var messagesService: PrivateMessagesService
    
    func makeMessageDetailComponent(for message: MessageIdentifier) -> UIViewController {
        let scene = sceneFactory.makeMessageDetailScene()
        
        _ = MessageDetailPresenter(message: message, scene: scene, messagesService: messagesService)
        
        return scene
    }
    
}
