import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithNoPoster_EventDetailViewModelFactoryShould: XCTestCase {

    func testNotForcefullyIncludeGraphicComponent() {
        let eventWithoutBanner = FakeEvent.random
        eventWithoutBanner.posterGraphicPNGData = nil
        _ = EventDetailViewModelFactoryTestBuilder().build(for: eventWithoutBanner)
    }

}
