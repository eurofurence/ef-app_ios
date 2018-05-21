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
    
    func testAdaptEventTitleIntoViewModel() {
        XCTAssertEqual(event.title, viewModel?.title)
    }
    
    func testFormatStartAndEndTimesIntoViewModel() {
        let expected = dateRangeFormatter.string(from: event.startDate, to: event.endDate)
        XCTAssertEqual(expected, viewModel?.eventStartEndTime)
    }
    
    func testFormatRoomNameIntoViewModelLocation() {
        XCTAssertEqual(event.room.name, viewModel?.location)
    }
    
}
