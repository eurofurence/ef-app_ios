import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class SchedulePresenterSuperSponsorIconBindingTests: XCTestCase {

    func testShowTheSponsorOnlyIndicator() {
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(searchResult)

        XCTAssertEqual(component.superSponsorIconVisibility, .visible)
    }

    func testHideTheSponsorOnlyIndicator() {
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isSuperSponsorOnly = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(searchResult)

        XCTAssertEqual(component.superSponsorIconVisibility, .hidden)
    }

}
