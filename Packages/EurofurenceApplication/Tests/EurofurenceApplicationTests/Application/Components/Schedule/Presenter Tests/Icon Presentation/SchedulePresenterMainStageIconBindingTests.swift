import EurofurenceApplication
import EurofurenceModel
import XCTest

class SchedulePresenterMainStageIconBindingTests: XCTestCase {

    func testShowTheMainStageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isMainStageEvent = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.mainStageIconVisibility, .visible)
    }

    func testHideTheMainStageIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isMainStageEvent = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.mainStageIconVisibility, .hidden)
    }

}
