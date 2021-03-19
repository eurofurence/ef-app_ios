import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForEventWithNoPoster_EventDetailViewModelFactoryShould: XCTestCase {

    func testNotForcefullyIncludeGraphicComponent() {
        let eventWithoutBanner = FakeEvent.random
        eventWithoutBanner.posterGraphicPNGData = nil
        _ = EventDetailViewModelFactoryTestBuilder().build(for: eventWithoutBanner)
    }

}
