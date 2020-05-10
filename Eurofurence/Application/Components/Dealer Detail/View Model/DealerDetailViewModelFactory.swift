import EurofurenceModel
import Foundation

protocol DealerDetailViewModelFactory {

    func makeDealerDetailViewModel(
        for identifier: DealerIdentifier,
        completionHandler: @escaping (DealerDetailViewModel) -> Void
    )

}
