import EurofurenceApplication
import EurofurenceModel
import Foundation

class CapturingDealersSearchViewModelDelegate: DealersSearchViewModelDelegate {

    private(set) var capturedSearchResults = [DealersGroupViewModel]()
    private(set) var capturedIndexTitles = [String]()
    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        capturedSearchResults = groups
        capturedIndexTitles = indexTitles
    }

}
