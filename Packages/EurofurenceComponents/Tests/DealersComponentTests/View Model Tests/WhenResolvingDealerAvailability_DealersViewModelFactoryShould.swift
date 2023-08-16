import DealersComponent
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenResolvingDealerAvailability_DealersViewModelFactoryShould: XCTestCase {

    func testInferAllDaysAvailabilityWhenAttendingOnAllThreeDaysOnly() {
        assertIsPresentForAllDays(
            true,
            isAttendingOnThursday: true,
            isAttendingOnFriday: true,
            isAttendingOnSaturday: true
        )
        
        assertIsPresentForAllDays(
            true,
            isAttendingOnThursday: false,
            isAttendingOnFriday: false,
            isAttendingOnSaturday: false
        )
        
        assertIsPresentForAllDays(
            false,
            isAttendingOnThursday: false,
            isAttendingOnFriday: true,
            isAttendingOnSaturday: true
        )
        
        assertIsPresentForAllDays(
            false,
            isAttendingOnThursday: true,
            isAttendingOnFriday: false,
            isAttendingOnSaturday: true
        )
        
        assertIsPresentForAllDays(
            false,
            isAttendingOnThursday: true,
            isAttendingOnFriday: true,
            isAttendingOnSaturday: false
        )
    }
    
    private func assertIsPresentForAllDays(
        _ expected: Bool,
        isAttendingOnThursday: Bool,
        isAttendingOnFriday: Bool,
        isAttendingOnSaturday: Bool,
        _ line: UInt = #line
    ) {
        let dealer = FakeDealer.random
        dealer.isAttendingOnThursday = isAttendingOnThursday
        dealer.isAttendingOnFriday = isAttendingOnFriday
        dealer.isAttendingOnSaturday = isAttendingOnSaturday
        let group = AlphabetisedDealersGroup(indexingString: .random, dealers: [dealer])
        let index = FakeDealersIndex(alphabetisedDealers: [group])
        let dealersService = FakeDealersService(index: index)
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.viewModelFactory.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(expected, dealerViewModel?.isPresentForAllDays)
    }

}
