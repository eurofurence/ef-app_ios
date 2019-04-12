@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerComponent_ForDealerWithoutAfterDarkContent_DealersPresenterShould: XCTestCase {

    func testHideTheAfterDarkWarning() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isAfterDarkContentPresent = false
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(component.didHideAfterDarkContentWarning)
    }

    func testNotShowTheAfterDarkWarning() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isAfterDarkContentPresent = false
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))

        XCTAssertFalse(component.didShowAfterDarkContentWarning)
    }

}
