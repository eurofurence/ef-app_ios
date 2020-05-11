import Eurofurence
import EurofurenceModel
import Foundation

class CapturingDealersViewModelDelegate: DealersViewModelDelegate {

    private(set) var capturedGroups = [DealersGroupViewModel]()
    private(set) var capturedIndexTitles = [String]()
    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        capturedGroups = groups
        capturedIndexTitles = indexTitles
    }

    private(set) var toldRefreshDidBegin = false
    func dealersRefreshDidBegin() {
        toldRefreshDidBegin = true
    }

    private(set) var toldRefreshDidFinish = false
    func dealersRefreshDidFinish() {
        toldRefreshDidFinish = true
    }

}

extension CapturingDealersViewModelDelegate {

    func capturedDealerViewModel(at indexPath: IndexPath) -> DealerViewModel? {
        guard capturedGroups.count > indexPath.section else { return nil }

        let group = capturedGroups[indexPath.section]
        guard group.dealers.count > indexPath.item else { return nil }

        return group.dealers[indexPath.item]
    }

}
