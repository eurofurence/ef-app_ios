import EurofurenceModel
import Foundation

class DefaultDealerDetailInteractor: DealerDetailInteractor {

    private let dealersService: DealersService

    convenience init() {
        self.init(dealersService: SharedModel.instance.services.dealers)
    }

    init(dealersService: DealersService) {
        self.dealersService = dealersService
    }

    func makeDealerDetailViewModel(for identifier: DealerIdentifier,
                                   completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        guard let dealer = dealersService.fetchDealer(for: identifier) else { return }
        dealer.fetchExtendedDealerData(completionHandler: { (data) in
            completionHandler(DefaultDealerDetailViewModel(dealer: dealer,
                                                           data: data,
                                                           dealerIdentifier: identifier,
                                                           dealersService: self.dealersService))
        })
    }

}
