import DealersComponent
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

class CapturingDealersSearchViewModel: DealersSearchViewModel {

    var dealerGroups: [DealersGroupViewModel]
    var sectionIndexTitles: [String]

    init(dealerGroups: [DealersGroupViewModel] = .random, sectionIndexTitles: [String] = .random) {
        self.dealerGroups = dealerGroups
        self.sectionIndexTitles = sectionIndexTitles
    }

    func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate) {
        delegate.dealerSearchResultsDidChange(dealerGroups, indexTitles: sectionIndexTitles)
    }

    private(set) var capturedSearchQuery: String?
    func updateSearchResults(with query: String) {
        capturedSearchQuery = query
    }

    fileprivate var dealerIdentifiers = [IndexPath: DealerIdentifier]()
    func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier? {
        return dealerIdentifiers[indexPath]
    }

}

extension CapturingDealersSearchViewModel {

    func stub(_ identifier: DealerIdentifier, forDealerAt indexPath: IndexPath) {
        dealerIdentifiers[indexPath] = identifier
    }

}
