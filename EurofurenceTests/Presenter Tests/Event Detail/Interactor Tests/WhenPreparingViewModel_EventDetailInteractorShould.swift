//
//  WhenPreparingViewModel_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_EventDetailInteractorShould: XCTestCase {
    
    func testAdaptEventTitleIntoViewModel() {
        let event = Event2.random
        let interactor = DefaultEventDetailInteractor(dateRangeFormatter: FakeDateRangeFormatter())
        var viewModel: EventDetailViewModel?
        interactor.makeViewModel(for: event) { viewModel = $0 }
        
        XCTAssertEqual(event.title, viewModel?.title)
    }
    
    func testFormatStartAndEndTimesIntoViewModel() {
        let dateRangeFormatter = FakeDateRangeFormatter()
        let event = Event2.random
        let interactor = DefaultEventDetailInteractor(dateRangeFormatter: dateRangeFormatter)
        var viewModel: EventDetailViewModel?
        interactor.makeViewModel(for: event) { viewModel = $0 }
        let expected = dateRangeFormatter.string(from: event.startDate, to: event.endDate)
        
        XCTAssertEqual(expected, viewModel?.eventStartEndTime)
    }
    
}
