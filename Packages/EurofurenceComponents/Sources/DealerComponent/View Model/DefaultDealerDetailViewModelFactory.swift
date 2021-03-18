import ComponentBase
import EurofurenceModel
import Foundation

public struct DefaultDealerDetailViewModelFactory: DealerDetailViewModelFactory {

    private let dealersService: DealersService
    private let shareService: ShareService
    
    public init(dealersService: DealersService, shareService: ShareService) {
        self.dealersService = dealersService
        self.shareService = shareService
    }

    public func makeDealerDetailViewModel(
        for identifier: DealerIdentifier,
        completionHandler: @escaping (DealerDetailViewModel) -> Void
    ) {
        guard let dealer = dealersService.fetchDealer(for: identifier) else { return }
        dealer.fetchExtendedDealerData(completionHandler: { (data) in
            completionHandler(DefaultDealerDetailViewModel(
                dealer: dealer,
                data: data,
                dealerIdentifier: identifier,
                dealersService: self.dealersService,
                shareService: self.shareService
            ))
        })
    }

}
