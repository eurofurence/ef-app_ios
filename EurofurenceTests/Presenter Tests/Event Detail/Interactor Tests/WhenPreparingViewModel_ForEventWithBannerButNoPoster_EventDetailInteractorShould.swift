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
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel.describe(componentAt: 0, to: visitor)

        XCTAssertEqual([context.makeExpectedEventGraphicViewModel()], visitor.visitedViewModels)
    }

}
