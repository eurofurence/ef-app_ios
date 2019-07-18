import EurofurenceModel
import Foundation

protocol DealersViewModel {

    func setDelegate(_ delegate: DealersViewModelDelegate)
    func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier?
    func refresh()

}

protocol DealersViewModelDelegate {

    func dealersRefreshDidBegin()
    func dealersRefreshDidFinish()
    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}

protocol DealerCategoriesViewModel {
    
    var numberOfCategories: Int { get }
    
}

protocol DealerCategoryViewModel {
    
    var title: String { get }
    
}
