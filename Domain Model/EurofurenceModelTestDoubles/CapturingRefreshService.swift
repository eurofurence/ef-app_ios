import EurofurenceModel
import Foundation

public class CapturingRefreshService: RefreshService {

    public init() {

    }

    private var refreshCompletionHandler: ((RefreshServiceError?) -> Void)?
    public private(set) var toldToRefresh = false
    fileprivate var refreshProgress: Progress?
    public func refreshLocalStore(completionHandler: @escaping (RefreshServiceError?) -> Void) -> Progress {
        toldToRefresh = true
        refreshCompletionHandler = completionHandler
        let refreshProgress = Progress()
        self.refreshProgress = refreshProgress

        return refreshProgress
    }

    private(set) var refreshObservers = [RefreshServiceObserver]()
    public func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }

    public func failLastRefresh(error: RefreshServiceError = .apiError) {
        refreshCompletionHandler?(error)
    }

    public func succeedLastRefresh() {
        refreshCompletionHandler?(nil)
    }

    public func updateProgressForCurrentRefresh(currentUnitCount: Int, totalUnitCount: Int) {
        refreshProgress?.totalUnitCount = Int64(totalUnitCount)
        refreshProgress?.completedUnitCount = Int64(currentUnitCount)
    }

}

public extension CapturingRefreshService {

    func simulateRefreshBegan() {
        refreshObservers.forEach { $0.refreshServiceDidBeginRefreshing() }
    }

    func simulateRefreshFinished() {
        refreshObservers.forEach { $0.refreshServiceDidFinishRefreshing() }
    }

}
