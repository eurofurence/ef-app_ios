import EurofurenceModel
import Foundation

public protocol DealersSearchViewModel {

    func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate)
    func updateSearchResults(with query: String)
    func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier?

}

public protocol DealersSearchViewModelDelegate {

    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}
