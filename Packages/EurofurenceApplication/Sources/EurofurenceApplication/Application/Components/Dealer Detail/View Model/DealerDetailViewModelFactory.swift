import EurofurenceModel
import Foundation

public protocol DealerDetailViewModelFactory {

    func makeDealerDetailViewModel(
        for identifier: DealerIdentifier,
        completionHandler: @escaping (DealerDetailViewModel) -> Void
    )

}
