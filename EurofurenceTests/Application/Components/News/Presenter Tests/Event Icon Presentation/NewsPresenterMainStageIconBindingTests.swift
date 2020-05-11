import Eurofurence
import EurofurenceModel
import XCTest

class NewsPresenterMainStageIconBindingTests: XCTestCase {

    func testShowTheMainStageIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isMainStageEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.mainStageIconVisibility, .visible)
    }

    func testHideTheMainStageIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isMainStageEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.mainStageIconVisibility, .hidden)
    }

}
