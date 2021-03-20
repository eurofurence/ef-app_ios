import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

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
