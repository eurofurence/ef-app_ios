@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingIconDataForDealerWithoutAvatar_DealersViewModelFactoryShould: XCTestCase {

    func testSupplyTheStockIconData() {
        let dealer = FakeDealer.random
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let defaultIconData = Data.random
        let context = DealersViewModelTestBuilder().with(dealersService).with(defaultIconData).build()
        var viewModel: DealersViewModel?
        context.viewModelFactory.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))
        var actual: Data?
        dealerViewModel?.fetchIconPNGData { actual = $0 }

        XCTAssertEqual(defaultIconData, actual)
    }

}
