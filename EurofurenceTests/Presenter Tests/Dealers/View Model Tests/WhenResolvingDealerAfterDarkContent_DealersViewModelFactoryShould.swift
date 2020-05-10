@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenResolvingDealerAfterDarkContent_DealersViewModelFactoryShould: XCTestCase {

    func testIdentifyWhetherDealerContainsAfterDarkContentFromModel() {
        let dealer = FakeDealer.random
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.viewModelFactory.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(dealer.isAfterDark, dealerViewModel?.isAfterDarkContentPresent)
    }

}
