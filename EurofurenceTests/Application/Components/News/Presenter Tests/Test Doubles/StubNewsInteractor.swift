import Eurofurence
import EurofurenceModel

struct StubNewsViewModelProducer: NewsViewModelProducer {

    var viewModel: NewsViewModel

    func subscribeViewModelUpdates(_ delegate: NewsViewModelRecipient) {
        delegate.viewModelDidUpdate(viewModel)
    }

    func refresh() {

    }

}
