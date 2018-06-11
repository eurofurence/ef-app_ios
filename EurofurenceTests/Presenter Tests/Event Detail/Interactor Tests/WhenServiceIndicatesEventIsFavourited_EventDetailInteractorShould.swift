//
//  WhenServiceIndicatesEventIsFavourited_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenServiceIndicatesEventIsFavourited_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheViewModelDelegateTheEventIsFavourited() {
        var event = Event2.random
        event.isFavourite = false
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.favourite()
        context.eventsService.simulateEventFavourited(identifier: event.identifier)
        
        XCTAssertTrue(delegate.toldEventFavourited)
    }
    
    func testNotTellTheViewModelDelegateTheEventIsFavouritedWhenNotInFavouriteIdentifiers() {
        var event = Event2.random
        event.isFavourite = false
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.favourite()
        context.eventsService.simulateEventFavourited(identifier: .random)
        
        XCTAssertFalse(delegate.toldEventFavourited)
    }
    
}
