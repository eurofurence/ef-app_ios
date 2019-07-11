import EurofurenceModel
import Foundation

struct DefaultDealerDetailInteractor: DealerDetailInteractor {

    var dealersService: DealersService
    var shareService: ShareService

    func makeDealerDetailViewModel(for identifier: DealerIdentifier,
                                   completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        guard let dealer = dealersService.fetchDealer(for: identifier) else { return }
        dealer.fetchExtendedDealerData(completionHandler: { (data) in
            completionHandler(DefaultDealerDetailViewModel(dealer: dealer,
                                                           data: data,
                                                           dealerIdentifier: identifier,
                                                           dealersService: self.dealersService,
                                                           shareService: self.shareService))
        })
    }

}
