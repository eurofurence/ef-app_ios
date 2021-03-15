import EurofurenceApplication
import EurofurenceModel
import Foundation

class FakeNewsViewModelProducer: NewsViewModelProducer {

    var lastCreatedViewModel: StubNewsViewModel = .random
    private(set) var didPrepareViewModel = false
    fileprivate var delegate: NewsViewModelRecipient?
    func subscribeViewModelUpdates(_ delegate: NewsViewModelRecipient) {
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

extension FakeNewsViewModelProducer {

    func simulateRefreshBegan() {
        delegate?.refreshDidBegin()
    }

    func simulateRefreshFinished() {
        delegate?.refreshDidFinish()
    }

}
