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
        
        messagesService.fetchMessage(identifiedBy: message) { (result) in
            self.scene.hideLoadingIndicator()
            
            if case .success(let message) = result {
                self.scene.setMessageDetailTitle(message.authorName)
                self.scene.addMessageComponent(with: Binder(message: message))
            }
        }
    }
    
    private struct Binder: MessageComponentBinder {
        
        var message: Message
        
        func bind(_ component: MessageComponent) {
            component.setMessageSubject(message.subject)
            component.setMessageContents(message.contents)
        }
        
    }
    
}
