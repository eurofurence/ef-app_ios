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

class JournallingRefreshServiceObserver: CapturingRefreshServiceObserver {
    
    private(set) var numberOfTimesToldDidBeginRefreshing = 0
    
    override func refreshServiceDidBeginRefreshing() {
        super.refreshServiceDidBeginRefreshing()
        numberOfTimesToldDidBeginRefreshing += 1
    }
    
}
