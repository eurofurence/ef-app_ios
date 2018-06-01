//
//  WhenPreparingViewModel_ForEventThatIsFavourite_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_ForEventThatIsFavourite_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheDelegateItIsAFavourite() {
        var event = Event2.random
        event.isFavourite = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        
        XCTAssertTrue(delegate.toldEventFavourited)
    }
    
    func testNotTellTheDelegateItIsUnfavourited() {
        var event = Event2.random
        event.isFavourite = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        
        XCTAssertFalse(delegate.toldEventUnfavourited)
    }
    
}
