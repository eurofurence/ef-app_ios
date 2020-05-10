@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class DealersViewModelTestBuilder {

    struct Context {
        var interactor: DefaultDealersViewModelFactory
        var dealersService: FakeDealersService
        var defaultIconData: Data
        var refreshService: CapturingRefreshService
    }

    private var dealersService: FakeDealersService
    private var defaultIconData: Data

    init() {
        dealersService = FakeDealersService()
        defaultIconData = Data()
    }

    @discardableResult
    func with(_ dealersService: FakeDealersService) -> DealersViewModelTestBuilder {
        self.dealersService = dealersService
        return self
    }

    @discardableResult
    func with(_ defaultIconData: Data) -> DealersViewModelTestBuilder {
        self.defaultIconData = defaultIconData
        return self
    }

    func build() -> Context {
        let refreshService = CapturingRefreshService()
        let interactor = DefaultDealersViewModelFactory(dealersService: dealersService,
                                                  defaultIconData: defaultIconData,
                                                  refreshService: refreshService)

        return Context(interactor: interactor,
                       dealersService: dealersService,
                       defaultIconData: defaultIconData,
                       refreshService: refreshService)
    }

}

extension DealersViewModelTestBuilder.Context {

    @discardableResult
    func prepareViewModel() -> DealersViewModel? {
        var viewModel: DealersViewModel?
        interactor.makeDealersViewModel { viewModel = $0 }

        return viewModel
    }
    
    func prepareCategoriesViewModel() -> DealerCategoriesViewModel? {
        var viewModel: DealerCategoriesViewModel?
        interactor.makeDealerCategoriesViewModel { viewModel = $0 }
        
        return viewModel
    }

}
