//
//  WhenPreparingViewModelForEventWithNoDescription_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModelForEventWithNoDescription_EventDetailInteractorShould: XCTestCase {
    
    func testNotContainDescription() {
        var event = Event2.random
        event.eventDescription = ""
        
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        
        if let viewModel = context.viewModel {
            (0..<viewModel.numberOfComponents).forEach({ viewModel.describe(componentAt: $0, to: visitor) })
        }
        
        let unexpected = context.makeExpectedEventDescriptionViewModel()
        XCTAssertFalse(visitor.visitedViewModels.contains(unexpected))
    }
    
}
