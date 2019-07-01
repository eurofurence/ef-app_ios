import Foundation

public protocol RefreshCollaboration {
    
    func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void)
    
}
