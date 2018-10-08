//
//  WhenPreparingViewModel_ForMainStageEvent_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenPreparingViewModel_ForMainStageEvent_EventDetailInteractorShould: XCTestCase {
    
    func testProduceMainStageComponentHeadingAfterDescriptionComponent() {
        var event = Event2.randomStandardEvent
        event.isMainStage = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventMainStageMessageViewModel(message: .mainStageEvent)
        
        XCTAssertEqual([expected], visitor.visitedViewModels)
    }
    
}
