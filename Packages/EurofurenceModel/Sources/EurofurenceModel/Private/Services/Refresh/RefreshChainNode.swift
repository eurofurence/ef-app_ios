import Foundation

class RefreshChainNode {
    
    private var next: RefreshChainNode?
    private var chainComplete: ((RefreshServiceError?) -> Void)?
    
    init(next: RefreshChainNode?) {
        self.next = next
    }
    
    func start(progress: Progress, chainComplete: ((RefreshServiceError?) -> Void)?) {
        self.chainComplete = chainComplete
    }
    
    final func finish(progress: Progress, error: RefreshServiceError?) {
        if let error = error {
            chainComplete?(error)
        } else if let next = next {
            next.start(progress: progress, chainComplete: chainComplete)
        } else {
            chainComplete?(nil)
        }
    }
    
}
