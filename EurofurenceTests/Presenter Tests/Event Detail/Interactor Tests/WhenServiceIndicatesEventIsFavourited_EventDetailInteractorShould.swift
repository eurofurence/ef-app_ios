//
//  WhenServiceIndicatesEventIsFavourited_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenServiceIndicatesEventIsFavourited_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheViewModelDelegateTheEventIsFavourited() {
        let event = Event2.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.favourite()
        
        XCTAssertTrue(delegate.toldEventFavourited)
    }
    
    func testNotTellTheViewModelDelegateTheEventIsFavouritedWhenNotInFavouriteIdentifiers() {
        let event = Event2.random
        let service = FakeEventsService(favourites: [])
        let context = EventDetailInteractorTestBuilder().with(service).build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.eventsService.simulateEventFavourited(identifier: .random)
        
        XCTAssertFalse(delegate.toldEventFavourited)
    }
    
}
