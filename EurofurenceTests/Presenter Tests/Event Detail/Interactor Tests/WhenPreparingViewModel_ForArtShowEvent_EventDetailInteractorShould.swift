//
//  WhenPreparingViewModel_ForArtShowEvent_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenPreparingViewModel_ForArtShowEvent_EventDetailInteractorShould: XCTestCase {
    
    func testProduceArtShowComponentHeadingAfterDescriptionComponent() {
        var event = Event.randomStandardEvent
        event.isArtShow = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventArtShowMessageViewModel(message: .artShow)
        
        XCTAssertEqual([expected], visitor.visitedViewModels)
    }
    
}
