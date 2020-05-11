import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterPhotoshootIconBindingTests: XCTestCase {

    func testShowThePhotoshootIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isPhotoshootEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.photoshootIconVisibility, .visible)
    }

    func testHideThePhotoshootIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isPhotoshootEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.photoshootIconVisibility, .hidden)
    }

}
