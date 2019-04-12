import EurofurenceModel
import Foundation

protocol DealersSearchViewModel {

    func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate)
    func updateSearchResults(with query: String)
    func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier?

}

protocol DealersSearchViewModelDelegate {

    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}
