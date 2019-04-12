@testable import Eurofurence
import EurofurenceModel
import XCTest

class NewsPresenterPhotoshootIconBindingTests: XCTestCase {

    func testShowThePhotoshootIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isPhotoshootEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.photoshootIconVisibility, .visible)
    }

    func testHideThePhotoshootIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isPhotoshootEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.photoshootIconVisibility, .hidden)
    }

}
