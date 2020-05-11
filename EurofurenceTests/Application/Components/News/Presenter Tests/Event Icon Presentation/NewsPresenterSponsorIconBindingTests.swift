import Eurofurence
import EurofurenceModel
import XCTest

class NewsPresenterSponsorIconBindingTests: XCTestCase {

    func testShowTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.sponsorIconVisibility, .visible)
    }

    func testHideTheSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.sponsorIconVisibility, .hidden)
    }

}
