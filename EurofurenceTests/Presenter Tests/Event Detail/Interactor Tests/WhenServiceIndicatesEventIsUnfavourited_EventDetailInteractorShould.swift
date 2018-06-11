//
//  WhenServiceIndicatesEventIsUnfavourited_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenServiceIndicatesEventIsUnfavourited_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheViewModelDelegateTheEventIsUnfavourited() {
        var event = Event2.random
        event.isFavourite = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.unfavourite()
        
        XCTAssertTrue(delegate.toldEventUnfavourited)
    }
    
    func testNotTellTheViewModelDelegateTheEventIsUnfavouritedWhenAnotherEventIsUnfavourited() {
        var event = Event2.random
        event.isFavourite = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        context.viewModel?.favourite()
        context.eventsService.simulateEventUnfavourited(identifier: .random)
        
        XCTAssertFalse(delegate.toldEventUnfavourited)
    }
    
}
