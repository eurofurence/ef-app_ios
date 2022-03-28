import EurofurenceApplication
import EurofurenceModel
import XCTest

class NewsPresenterDealersDenIconBindingTests: XCTestCase {

    func testShowTheDealersDenIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isDealersDenEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.dealersDenIconVisibility, .visible)
    }

    func testHideTheDealersDenIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isDealersDenEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.dealersDenIconVisibility, .hidden)
    }

}
