import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingDealerComponent_ForDealerNotPresentOnAllDays_DealersPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheNotPresentOnAllDaysWarning() {
        let component = prepareDealerComponent(isPresentForAllDays: false)

        XCTAssertTrue(component.didShowNotPresentOnAllDaysWarning)
        XCTAssertFalse(component.didHideNotPresentOnAllDaysWarning)
    }
    
    func testNotShowTheWarningIndicatingTheyAreNotPresentOnAllDays() {
        let component = prepareDealerComponent(isPresentForAllDays: true)

        XCTAssertFalse(component.didShowNotPresentOnAllDaysWarning)
        XCTAssertTrue(component.didHideNotPresentOnAllDaysWarning)
    }
    
    private func prepareDealerComponent(isPresentForAllDays: Bool) -> CapturingDealerComponent {
        let dealerViewModel = StubDealerViewModel.random
        dealerViewModel.isPresentForAllDays = isPresentForAllDays
        let viewModelFactory = FakeDealersViewModelFactory(dealerViewModel: dealerViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        
        return context.makeAndBindDealer(at: IndexPath(item: 0, section: 0))
    }

}
