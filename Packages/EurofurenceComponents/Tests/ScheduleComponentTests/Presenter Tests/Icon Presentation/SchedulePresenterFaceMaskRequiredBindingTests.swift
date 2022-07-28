import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class SchedulePresenterFaceMaskRequiredBindingTests: XCTestCase {
    
    func testShowTheFaceMaskRequiredIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFaceMaskRequired = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.faceMaskIconVisibility, .visible)
    }
    
    func testHideTheFaceMaskRequiredIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFaceMaskRequired = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.faceMaskIconVisibility, .hidden)
    }

}
