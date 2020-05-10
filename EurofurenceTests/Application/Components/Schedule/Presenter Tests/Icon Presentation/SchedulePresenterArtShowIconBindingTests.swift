@testable import Eurofurence
import EurofurenceModel
import XCTest

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
