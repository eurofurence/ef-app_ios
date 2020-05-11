import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterDealersDenIconBindingTests: XCTestCase {

    func testShowTheDealersDenIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isDealersDenEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.dealersDenIconVisibility, .visible)
    }

    func testHideTheDealersDenIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isDealersDenEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.dealersDenIconVisibility, .hidden)
    }

}
