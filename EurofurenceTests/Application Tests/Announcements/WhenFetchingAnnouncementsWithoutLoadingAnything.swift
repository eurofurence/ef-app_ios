//
//  WhenFetchingAnnouncementsWithoutLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingAnnouncementsWithoutLoadingAnything: XCTestCase {
    
    func testEmptyAnnouncementsAreReturned() {
        let context = ApplicationTestBuilder().build()
        let emptyAnnouncementsExpectation = expectation(description: "Should have given an empty announcements array")
        context.application.fetchAnnouncements { (announcements) in
            if announcements.isEmpty {
                emptyAnnouncementsExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
}
