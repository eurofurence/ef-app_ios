import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class SchedulePresenterArtShowIconBindingTests: XCTestCase {

    func testShowTheArtShowIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isArtShow = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.artShowIconVisibility, .visible)
    }

    func testHideTheArtShowIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isArtShow = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.artShowIconVisibility, .hidden)
    }

}
