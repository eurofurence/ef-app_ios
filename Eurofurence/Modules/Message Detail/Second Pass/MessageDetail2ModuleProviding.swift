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
        loadMessageForPresentation()
    }
    
    private func loadMessageForPresentation() {
        scene.showLoadingIndicator()
        
        messagesService.fetchMessage(identifiedBy: message) { (result) in
            self.scene.hideLoadingIndicator()
            
            switch result {
            case .success(let message):
                self.scene.setMessageDetailTitle(message.authorName)
                self.scene.showMessage(viewModel: MessageViewModel(message: message))
                
            case .failure(let error):
                self.scene.showError(viewModel: ErrorViewModel(error: error, retryHandler: self.loadMessageForPresentation))
            }
        }
    }
    
    private struct MessageViewModel: MessageDetailViewModel {
        
        private let message: Message
        
        init(message: Message) {
            self.message = message
        }
        
        var subject: String {
            message.subject
        }
        
        var contents: String {
            message.contents
        }
        
    }
    
    private struct ErrorViewModel: MessageDetailErrorViewModel {
        
        private let error: Error
        private let retryHandler: () -> Void
        
        init(error: Error, retryHandler: @escaping () -> Void) {
            self.error = error
            self.retryHandler = retryHandler
        }
        
        var errorDescription: String {
            error.localizedDescription
        }
        
        func retry() {
            retryHandler()
        }
        
    }
    
}
