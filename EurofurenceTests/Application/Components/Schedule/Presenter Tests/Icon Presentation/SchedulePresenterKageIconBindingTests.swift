import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterKageIconBindingTests: XCTestCase {

    func testShowTheKageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isKageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.kageIconVisibility, .visible)
    }

    func testHideTheKageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isKageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.kageIconVisibility, .hidden)
    }

}
