import EurofurenceModel
import Foundation

class CapturingRefreshServiceObserver: RefreshServiceObserver {
    
    enum State {
        case unset
        case refreshing
        case finishedRefreshing
    }
    
    private(set) var state: State = .unset

    func refreshServiceDidBeginRefreshing() {
        state = .refreshing
    }

    func refreshServiceDidFinishRefreshing() {
        state = .finishedRefreshing
    }

}
