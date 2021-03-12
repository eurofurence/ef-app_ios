import Foundation

class FetchPrivateMessages: RefreshChain.Node {
    
    private let privateMessagesController: ConcretePrivateMessagesService
    
    init(next: RefreshChain.Node?, privateMessagesController: ConcretePrivateMessagesService) {
        self.privateMessagesController = privateMessagesController
        super.init(next: next)
    }
    
    override func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
        super.start(progress: progress, chainComplete: chainComplete)
        
        privateMessagesController.refreshMessages { (_) in
            self.finish(progress: progress, error: nil)
        }
    }
    
}
