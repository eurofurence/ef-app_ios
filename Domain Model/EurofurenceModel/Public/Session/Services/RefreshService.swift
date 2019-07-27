import Foundation

public enum RefreshServiceError: Equatable, Error {
    
    public static func == (lhs: RefreshServiceError, rhs: RefreshServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.apiError, .apiError):
            return true
            
        case (.conventionIdentifierMismatch, .conventionIdentifierMismatch):
            return true
            
        case (.collaborationError(let l), .collaborationError(let r)):
            return (l as? AnyHashable) == (r as? AnyHashable)
            
        default:
            return false
        }
    }
    
    case apiError
    case conventionIdentifierMismatch
    case collaborationError(Error)
}

public protocol RefreshService {

    func add(_ observer: RefreshServiceObserver)

    @discardableResult
    func refreshLocalStore(completionHandler: @escaping (RefreshServiceError?) -> Void) -> Progress

}

public protocol RefreshServiceObserver {

    func refreshServiceDidBeginRefreshing()
    func refreshServiceDidFinishRefreshing()

}
