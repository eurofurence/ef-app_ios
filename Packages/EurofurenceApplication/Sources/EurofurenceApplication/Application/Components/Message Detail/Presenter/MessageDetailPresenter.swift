import EurofurenceModel
import Foundation

class MessageDetailPresenter: MessageDetailSceneDelegate {
    
    private let message: MessageIdentifier
    private weak var scene: MessageDetailScene?
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
        scene?.showLoadingIndicator()
        
        messagesService.fetchMessage(identifiedBy: message) { (result) in
            self.scene?.hideLoadingIndicator()
            
            switch result {
            case .success(let message):
                message.markAsRead()
                self.scene?.setMessageDetailTitle(message.authorName)
                self.scene?.showMessage(viewModel: MessageViewModel(message: message))
                
            case .failure(let error):
                self.scene?.showError(
                    viewModel: ErrorViewModel(error: error, retryHandler: self.loadMessageForPresentation)
                )
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
        
        var contents: NSAttributedString {
            NSAttributedString(string: message.contents)
        }
        
    }
    
    private struct ErrorViewModel: MessageDetailErrorViewModel {
        
        private let error: PrivateMessageError
        private let retryHandler: () -> Void
        
        init(error: PrivateMessageError, retryHandler: @escaping () -> Void) {
            self.error = error
            self.retryHandler = retryHandler
        }
        
        var errorDescription: String {
            error.errorDescription
        }
        
        func retry() {
            retryHandler()
        }
        
    }
    
}
