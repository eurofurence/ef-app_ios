@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithBannerButNoPoster_EventDetailInteractorShould: XCTestCase {

    func testProduceGraphicComponentUsingBannerData() {
        let event = FakeEvent.random
        let bannerGraphicData = Data.random
        event.posterGraphicPNGData = nil
        event.bannerGraphicPNGData = bannerGraphicData
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()

        XCTAssertEqual(context.makeExpectedEventGraphicViewModel(), visitor.visited(ofKind: EventGraphicViewModel.self))
    }

}
