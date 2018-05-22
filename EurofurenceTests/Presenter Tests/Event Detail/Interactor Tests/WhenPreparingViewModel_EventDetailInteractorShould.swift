//
//  WhenPreparingViewModel_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEventDetailViewModelVisitor: EventDetailViewModelVisitor {
    
    private(set) var visitedEventSummary: EventSummaryViewModel?
    func visit(_ summary: EventSummaryViewModel) {
        visitedEventSummary = summary
    }
    
}

class WhenPreparingViewModel_EventDetailInteractorShould: XCTestCase {
    
    var event: Event2!
    var dateRangeFormatter: FakeDateRangeFormatter!
    var interactor: DefaultEventDetailInteractor!
    var viewModel: EventDetailViewModel?
    
    override func setUp() {
        super.setUp()
        
        dateRangeFormatter = FakeDateRangeFormatter()
        event = .random
        interactor = DefaultEventDetailInteractor(dateRangeFormatter: dateRangeFormatter)
        interactor.makeViewModel(for: event) { self.viewModel = $0 }
    }
    
    func testProduceExpectedSummaryViewModelAtIndexZero() {
        let expected = EventSummaryViewModel(title: event.title,
                                             subtitle: event.abstract,
                                             eventStartEndTime: dateRangeFormatter.string(from: event.startDate, to: event.endDate),
                                             location: event.room.name,
                                             trackName: event.track.name,
                                             eventHosts: event.hosts,
                                             eventDescription: "")
        let visitor = CapturingEventDetailViewModelVisitor()
        viewModel?.describe(to: visitor)
        
        XCTAssertEqual(expected, visitor.visitedEventSummary)
    }
    
}
