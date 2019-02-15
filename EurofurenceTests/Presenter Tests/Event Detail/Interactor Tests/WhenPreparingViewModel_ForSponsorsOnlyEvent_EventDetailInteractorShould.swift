//
//  WhenPreparingViewModel_ForSponsorsOnlyEvent_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForSponsorsOnlyEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceSponsorsOnlyComponentHeadingAfterDescriptionComponent() {
        var event = StubEvent.random
        event.isSponsorOnly = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventSponsorsOnlyWarningViewModel(message: .thisEventIsForSponsorsOnly)

        XCTAssertEqual([expected], visitor.visitedViewModels)
    }

}
