@testable import Eurofurence
import EurofurenceModel

struct StubNewsInteractor: NewsInteractor {

    var viewModel: NewsViewModel

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        delegate.viewModelDidUpdate(viewModel)
    }

    func refresh() {

    }

}
