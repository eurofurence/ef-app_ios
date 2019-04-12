import EurofurenceModel
import Foundation

protocol DealerDetailInteractor {

    func makeDealerDetailViewModel(for identifier: DealerIdentifier, completionHandler: @escaping (DealerDetailViewModel) -> Void)

}
