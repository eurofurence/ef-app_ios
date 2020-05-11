import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

final class CapturingDealersViewModel: DealersViewModel {

    var dealerGroups: [DealersGroupViewModel]
    var sectionIndexTitles: [String] = .random

    init(dealerGroups: [DealersGroupViewModel] = .random) {
        self.dealerGroups = dealerGroups
    }

    private(set) var delegate: DealersViewModelDelegate?
    func setDelegate(_ delegate: DealersViewModelDelegate) {
        self.delegate = delegate
        delegate.dealerGroupsDidChange(dealerGroups, indexTitles: sectionIndexTitles)
    }

    fileprivate var dealerIdentifiers = [IndexPath: DealerIdentifier]()
    func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier? {
        return dealerIdentifiers[indexPath]
    }

    private(set) var wasToldToRefresh = false
    func refresh() {
        wasToldToRefresh = true
    }

}

extension CapturingDealersViewModel {

    func stub(_ identifier: DealerIdentifier, forDealerAt indexPath: IndexPath) {
        dealerIdentifiers[indexPath] = identifier
    }

}
