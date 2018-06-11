//
//  WhenUnfavouritingEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenUnfavouritingEvent_ApplicationShould: XCTestCase {
    
    func testTellTheDataStoreToDeleteTheEventIdentifier() {
        let context = ApplicationTestBuilder().build()
        let identifier = Event2.Identifier.random
        context.application.unfavouriteEvent(identifier: identifier)
        
        XCTAssertTrue(context.dataStore.didDeleteFavouriteEvent(identifier))
    }
    
}
