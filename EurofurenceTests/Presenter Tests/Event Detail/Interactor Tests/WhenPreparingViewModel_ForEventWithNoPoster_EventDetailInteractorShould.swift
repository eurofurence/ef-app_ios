//
//  WhenPreparingViewModel_ForEventWithNoPoster_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithNoPoster_EventDetailInteractorShould: XCTestCase {

    func testNotForcefullyIncludeGraphicComponent() {
        let eventWithoutBanner = StubEvent.random
        eventWithoutBanner.posterGraphicPNGData = nil
        _ = EventDetailInteractorTestBuilder().build(for: eventWithoutBanner)
    }

}
