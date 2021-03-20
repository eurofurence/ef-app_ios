import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class SchedulePresenterSponsorIconBindingTests: XCTestCase {

    func testShowTheSponsorOnlyIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.sponsorIconVisibility, .visible)
    }

    func testHideTheSponsorOnlyIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.sponsorIconVisibility, .hidden)
    }

}
