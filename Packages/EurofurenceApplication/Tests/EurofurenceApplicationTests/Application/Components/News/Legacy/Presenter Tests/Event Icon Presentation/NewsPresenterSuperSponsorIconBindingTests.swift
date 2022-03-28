import EurofurenceApplication
import EurofurenceModel
import XCTest

class NewsPresenterSuperSponsorIconBindingTests: XCTestCase {

    func testShowTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.superSponsorIconVisibility, .visible)
    }

    func testHideTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.superSponsorIconVisibility, .hidden)
    }

}
