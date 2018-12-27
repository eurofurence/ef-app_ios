//
//  WhenPreparingViewModel_ForEventWithBannerButNoPoster_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithBannerButNoPoster_EventDetailInteractorShould: XCTestCase {

    func testProduceGraphicComponentUsingBannerData() {
        var event = Event.random
        let bannerGraphicData = Data.random
        event.posterGraphicPNGData = nil
        event.bannerGraphicPNGData = bannerGraphicData
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 0, to: visitor)

        XCTAssertEqual([context.makeExpectedEventGraphicViewModel()], visitor.visitedViewModels)
    }

}
