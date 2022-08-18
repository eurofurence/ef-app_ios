import ComponentBase
import EurofurenceModel
import Foundation

class MessageDetailPresenter: MessageDetailSceneDelegate {
    
    private let message: MessageIdentifier
    private weak var scene: MessageDetailScene?
    private let messagesService: PrivateMessagesService
    private let markdownRenderer: MarkdownRenderer
    
    init(
        message: MessageIdentifier,
        scene: MessageDetailScene,
        messagesService: PrivateMessagesService,
        markdownRenderer: MarkdownRenderer
    ) {
        self.message = message
        self.scene = scene
        self.messagesService = messagesService
        self.markdownRenderer = markdownRenderer
        
        scene.delegate = self
    }
    
    func messageDetailSceneDidLoad() {
        loadMessageForPresentation()
    }
    
    private func loadMessageForPresentation() {
        scene?.showLoadingIndicator()
        
        messagesService.fetchMessage(identifiedBy: message) { [markdownRenderer] (result) in
            self.scene?.hideLoadingIndicator()
            
            switch result {
            case .success(let message):
                message.markAsRead()
                
                self.scene?.setMessageDetailTitle(message.authorName)
                self.scene?.showMessage(viewModel: MessageViewModel(message: message,
                                                                    markdownRenderer: markdownRenderer))
                
            case .failure(let error):
                self.scene?.showError(
                    viewModel: ErrorViewModel(error: error, retryHandler: self.loadMessageForPresentation)
                )
            }
        }
    }
    
    private struct MessageViewModel: MessageDetailViewModel {
        
        init(message: Message, markdownRenderer: MarkdownRenderer) {
            self.subject = message.subject
            self.contents = markdownRenderer.render(message.contents)
        }
        
        let subject: String
        let contents: NSAttributedString
        
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
