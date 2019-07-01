import Foundation

struct DoNothingRefreshCollaboration: RefreshCollaboration {
    
    func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void) {
        completionHandler(nil)
    }
    
}
