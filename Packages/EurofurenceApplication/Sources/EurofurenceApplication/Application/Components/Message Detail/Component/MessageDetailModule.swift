import ComponentBase
import EurofurenceModel
import UIKit

struct MessageDetailComponentFactoryImpl: MessageDetailComponentFactory {
    
    var sceneFactory: MessageDetailSceneFactory
    var messagesService: PrivateMessagesService
    var markdownRenderer: MarkdownRenderer
    
    func makeMessageDetailComponent(for message: MessageIdentifier) -> UIViewController {
        let scene = sceneFactory.makeMessageDetailScene()
        
        _ = MessageDetailPresenter(
            message: message,
            scene: scene,
            messagesService: messagesService,
            markdownRenderer: markdownRenderer
        )
        
        return scene
    }
    
}
