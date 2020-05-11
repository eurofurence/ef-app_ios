import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerAfterDarkStatus_DealersPresenterShould: XCTestCase {

    func testHideTheAfterDarkWarning() {
        let component = prepareDealerComponent(isAfterDarkContentPresent: false)

        XCTAssertTrue(component.didHideAfterDarkContentWarning)
        XCTAssertFalse(component.didShowAfterDarkContentWarning)
    }
    
    func testShowTheAfterDarkWarning() {
        let component = prepareDealerComponent(isAfterDarkContentPresent: true)

        XCTAssertTrue(component.didShowAfterDarkContentWarning)
        XCTAssertFalse(component.didHideAfterDarkContentWarning)
    }
    
    private func prepareDealerComponent(isAfterDarkContentPresent: Bool) -> CapturingDealerComponent {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isAfterDarkContentPresent = isAfterDarkContentPresent
        let viewModelFactory = FakeDealersViewModelFactory(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        
        return context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))
    }

}
