@testable import Eurofurence
import EurofurenceModel
import Foundation

class FakeNewsInteractor: NewsInteractor {

    var lastCreatedViewModel: StubNewsViewModel = .random
    private(set) var didPrepareViewModel = false
    fileprivate var delegate: NewsInteractorDelegate?
    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        self.delegate = delegate

        didPrepareViewModel = true
        let viewModel = StubNewsViewModel.random
        lastCreatedViewModel = viewModel
        delegate.viewModelDidUpdate(viewModel)
    }

    private(set) var didRefresh = false
    func refresh() {
        didRefresh = true
    }

}

extension FakeNewsInteractor {

    func simulateRefreshBegan() {
        delegate?.refreshDidBegin()
    }

    func simulateRefreshFinished() {
        delegate?.refreshDidFinish()
    }

}
