//
//  WhenPreparingViewModel_ForSuperSponsorsOnlyEvent_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForSuperSponsorsOnlyEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceSuperSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isSuperSponsorOnly = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventSuperSponsorsOnlyWarningViewModel(message: .thisEventIsForSuperSponsorsOnly)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
