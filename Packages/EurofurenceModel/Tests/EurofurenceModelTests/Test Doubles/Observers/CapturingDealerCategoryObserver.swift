import EurofurenceModel

class CapturingDealerCategoryObserver: DealerCategoryObserver {
    
    enum State {
        case unknown
        case active
        case inactive
    }
    
    private(set) var state: State = .unknown
    
    func categoryDidActivate(_ category: DealerCategory) {
        state = .active
    }
    
    func categoryDidDeactivate(_ category: DealerCategory) {
        state = .inactive
    }
    
}
