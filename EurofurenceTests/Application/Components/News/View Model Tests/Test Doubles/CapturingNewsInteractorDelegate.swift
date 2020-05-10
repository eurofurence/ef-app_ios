@testable import Eurofurence
import EurofurenceModel
import Foundation.NSIndexPath

class CapturingNewsViewModelRecipient: NewsViewModelRecipient {

    private(set) var viewModel: NewsViewModel?
    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }

    private(set) var toldRefreshDidBegin = false
    func refreshDidBegin() {
        toldRefreshDidBegin = true
    }

    private(set) var toldRefreshDidFinish = false
    func refreshDidFinish() {
        toldRefreshDidFinish = true
    }

}
