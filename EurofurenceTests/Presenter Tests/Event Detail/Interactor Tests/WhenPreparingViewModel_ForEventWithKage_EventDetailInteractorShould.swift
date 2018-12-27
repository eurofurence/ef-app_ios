//
//  WhenPreparingViewModel_ForEventWithKage_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenPreparingViewModel_ForEventWithKage_EventDetailInteractorShould: XCTestCase {

    func testProduceKageHeadingAfterDescriptionComponent() {
        var event = Event.randomStandardEvent
        event.isKageEvent = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventKageMessageViewModel(message: .kageGuestMessage)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
