import EurofurenceModel
import Foundation

public protocol DealersViewModel {

    func setDelegate(_ delegate: DealersViewModelDelegate)
    func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier?
    func refresh()

}

public protocol DealersViewModelDelegate {

    func dealersRefreshDidBegin()
    func dealersRefreshDidFinish()
    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}

public protocol DealerCategoriesViewModel {
    
    var numberOfCategories: Int { get }
    func categoryViewModel(at index: Int) -> DealerCategoryViewModel
    
}

public protocol DealerCategoryViewModel {
    
    var title: String { get }

    func add(_ observer: DealerCategoryViewModelObserver)
    func toggleCategoryActiveState()
    
}

public protocol DealerCategoryViewModelObserver {
    
    func categoryDidEnterActiveState()
    func categoryDidEnterInactiveState()
    
}
