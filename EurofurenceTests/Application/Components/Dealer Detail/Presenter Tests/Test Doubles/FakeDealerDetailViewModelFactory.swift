import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeDealerDetailViewModelFactory: DealerDetailViewModelFactory {

    private let viewModel: FakeDealerDetailViewModel

    convenience init() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        self.init(viewModel: viewModel)
    }

    init(viewModel: FakeDealerDetailViewModel) {
        self.viewModel = viewModel
    }

    private(set) var capturedIdentifierForProducingViewModel: DealerIdentifier?
    func makeDealerDetailViewModel(
        for identifier: DealerIdentifier,
        completionHandler: @escaping (DealerDetailViewModel) -> Void
    ) {
        capturedIdentifierForProducingViewModel = identifier
        completionHandler(viewModel)
    }

}
