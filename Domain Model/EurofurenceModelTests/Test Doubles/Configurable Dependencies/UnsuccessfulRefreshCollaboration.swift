import EurofurenceModel

struct UnsuccessfulRefreshCollaboration: RefreshCollaboration {
    
    var error: Error
    
    func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void) {
        completionHandler(error)
    }
    
}
