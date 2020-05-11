import Eurofurence

class FakeDealerCategoryViewModel: DealerCategoryViewModel {
    
    let title: String
    private var isActive: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    func add(_ observer: DealerCategoryViewModelObserver) {
        if isActive {
            observer.categoryDidEnterActiveState()
        } else {
            observer.categoryDidEnterInactiveState()
        }
    }
    
    private(set) var toldToToggleActiveState = false
    func toggleCategoryActiveState() {
        toldToToggleActiveState = true
    }
    
    func enterActiveState() {
        isActive = true
    }
    
    func enterInactiveState() {
        isActive = false
    }
    
}
