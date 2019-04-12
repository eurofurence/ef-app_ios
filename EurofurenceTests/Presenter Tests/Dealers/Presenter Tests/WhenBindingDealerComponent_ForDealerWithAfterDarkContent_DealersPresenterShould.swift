@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerComponent_ForDealerWithAfterDarkContent_DealersPresenterShould: XCTestCase {

    func testShowTheAfterDarkWarning() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isAfterDarkContentPresent = true
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(component.didShowAfterDarkContentWarning)
    }

    func testNotHideTheAfterDarkWarning() {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isAfterDarkContentPresent = true
        let interactor = FakeDealersInteractor(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))

        XCTAssertFalse(component.didHideAfterDarkContentWarning)
    }

}
