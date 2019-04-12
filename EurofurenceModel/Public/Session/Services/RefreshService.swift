import Foundation

public enum RefreshServiceError: Error {
    case apiError
    case conventionIdentifierMismatch
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
