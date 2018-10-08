//
//  WhenServiceIndicatesEventIsUnfavourited_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenServiceIndicatesEventIsUnfavourited_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheViewModelDelegateTheEventIsUnfavourited() {
        let event = Event2.random
        let service = FakeEventsService(favourites: [event.identifier])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.unfavourite()
        
        XCTAssertTrue(delegate.toldEventUnfavourited)
    }
    
    func testNotTellTheViewModelDelegateTheEventIsUnfavouritedWhenAnotherEventIsUnfavourited() {
        let event = Event2.random
        let service = FakeEventsService(favourites: [event.identifier])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.favourite()
        context.eventsService.simulateEventUnfavourited(identifier: .random)
        
        XCTAssertFalse(delegate.toldEventUnfavourited)
    }
    
}
