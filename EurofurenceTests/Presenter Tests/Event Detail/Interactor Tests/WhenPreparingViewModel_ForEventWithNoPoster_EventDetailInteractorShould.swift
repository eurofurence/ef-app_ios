@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithNoPoster_EventDetailInteractorShould: XCTestCase {

    func testNotForcefullyIncludeGraphicComponent() {
        let eventWithoutBanner = FakeEvent.random
        eventWithoutBanner.posterGraphicPNGData = nil
        _ = EventDetailInteractorTestBuilder().build(for: eventWithoutBanner)
    }

}
