import Eurofurence

class CapturingDealerCategoryViewModelObserver: DealerCategoryViewModelObserver {
    
    enum State {
        case unset
        case active
        case inactive
    }
    
    private(set) var state: State = .unset
    
    func categoryDidEnterActiveState() {
        state = .active
    }
    
    func categoryDidEnterInactiveState() {
        state = .inactive
    }
    
}
