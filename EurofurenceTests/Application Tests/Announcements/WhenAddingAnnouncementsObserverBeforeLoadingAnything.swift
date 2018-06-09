//
//  WhenAddingAnnouncementsObserverBeforeLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAddingAnnouncementsObserverBeforeLoadingAnything: XCTestCase {
    
    func testEmptyUnreadAnnouncementsAreReturned() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        XCTAssertTrue(observer.didReceieveEmptyUnreadAnnouncements)
    }
    
    func testEmptyAnnouncementsAreReturned() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
        
        XCTAssertTrue(observer.didReceieveEmptyAllAnnouncements)
    }
    
}
