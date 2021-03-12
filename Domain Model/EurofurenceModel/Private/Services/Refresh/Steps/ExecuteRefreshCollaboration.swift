import Foundation

class ExecuteRefreshCollaboration: RefreshChainNode {
    
    private let refreshCollaboration: RefreshCollaboration
    
    init(next: RefreshChainNode?, refreshCollaboration: RefreshCollaboration) {
        self.refreshCollaboration = refreshCollaboration
        super.init(next: next)
    }
    
    override func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
        super.start(progress: progress, chainComplete: chainComplete)
        
        refreshCollaboration.executeCollaborativeRefreshTask(completionHandler: { (error) in
            if error != nil {
                self.finish(progress: progress, error: .collaborationError)
            } else {
                self.finish(progress: progress, error: nil)
            }
        })
    }
    
}
