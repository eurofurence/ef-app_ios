import DealerComponent
import EurofurenceModel
import XCTComponentBase
import XCTEurofurenceModel

class DealerDetailViewModelFactoryTestBuilder {

    struct Context {
        var viewModelFactory: DefaultDealerDetailViewModelFactory
        var dealersService: FakeDealersService
        var dealerData: ExtendedDealerData
        var dealerIdentifier: DealerIdentifier
        var dealer: FakeDealer
        var shareService: CapturingShareService
    }

    func build(data: ExtendedDealerData = .random) -> Context {
        let dealersService = FakeDealersService()
        let dealer = FakeDealer.random
        dealer.extendedData = data
        dealersService.add(dealer)
        
        let shareService = CapturingShareService()
        let viewModelFactory = DefaultDealerDetailViewModelFactory(
            dealersService: dealersService, 
            shareService: shareService
        )

        return Context(
            viewModelFactory: viewModelFactory,
            dealersService: dealersService,
            dealerData: data,
            dealerIdentifier: dealer.identifier,
            dealer: dealer,
            shareService: shareService
        )
    }
    
}

extension DealerDetailViewModelFactoryTestBuilder.Context {

    func makeViewModel() -> DealerDetailViewModel? {
        var viewModel: DealerDetailViewModel?
        viewModelFactory.makeDealerDetailViewModel(for: dealerIdentifier) { viewModel = $0 }

        return viewModel
    }

}
