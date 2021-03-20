import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

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
