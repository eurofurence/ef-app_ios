//
//  WhenPreparingViewModelForEventWithIdenticalAbstractAndDescription_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModelForEventWithIdenticalAbstractAndDescription_EventDetailInteractorShould: XCTestCase {
    
    func testNotContainDescription() {
        var event = Event2.random
        event.eventDescription = event.abstract
        
        let context = EventDetailInteractorTestBuilder().build(for: event)
        
        let expected = EventSummaryViewModel(title: event.title,
                                             subtitle: event.abstract,
                                             eventStartEndTime: context.dateRangeFormatter.string(from: event.startDate, to: event.endDate),
                                             location: event.room.name,
                                             trackName: event.track.name,
                                             eventHosts: event.hosts)
        let visitor = CapturingEventDetailViewModelVisitor()
        
        if let viewModel = context.viewModel {
            (0..<viewModel.numberOfComponents).forEach({ viewModel.describe(componentAt: $0, to: visitor) })
        }
        
        XCTAssertEqual([expected], visitor.visitedViewModels)
    }
    
}
