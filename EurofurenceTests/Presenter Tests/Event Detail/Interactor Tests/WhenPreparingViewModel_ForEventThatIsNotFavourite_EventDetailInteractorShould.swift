//
//  WhenPreparingViewModel_ForEventThatIsNotFavourite_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_ForEventThatIsNotFavourite_EventDetailInteractorShould: XCTestCase {
    
    func testTellTheDelegateItIsUnfavourited() {
        var event = Event2.random
        event.isFavourite = false
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let delegate = CapturingEventDetailViewModelDelegate()
        context.viewModel?.setDelegate(delegate)
        
        XCTAssertTrue(delegate.toldEventUnfavourited)
    }
    
}
