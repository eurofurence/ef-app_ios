import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingIconDataForDealerWithAvatar_DealersViewModelFactoryShould: XCTestCase {

    func testSupplyTheAvatarFromTheDealersService() {
        let dealer = FakeDealer.random
        let expected = Data.random
        dealer.iconPNGData = expected
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.viewModelFactory.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))
        var actual: Data?
        dealerViewModel?.fetchIconPNGData { actual = $0 }

        XCTAssertEqual(expected, actual)
    }

}
