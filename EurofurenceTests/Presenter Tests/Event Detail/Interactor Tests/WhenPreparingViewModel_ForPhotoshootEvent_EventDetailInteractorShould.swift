//
//  WhenPreparingViewModel_ForPhotoshootEvent_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForPhotoshootEvent_EventDetailInteractorShould: XCTestCase {

    func testProducePhotoshootHeadingAfterDescriptionComponent() {
        var event = StubEvent.randomStandardEvent
        event.isPhotoshoot = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventPhotoshootMessageViewModel(message: .photoshoot)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
