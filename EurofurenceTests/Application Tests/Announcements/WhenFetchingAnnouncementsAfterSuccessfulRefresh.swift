//
//  WhenFetchingAnnouncementsAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingAnnouncementsAfterSuccessfulRefresh: XCTestCase {
    
    func testTheAnnouncementsFromTheRefreshResponseAreAdapted() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = syncResponse.announcements.changed.map { (announcement) -> Announcement2 in
            return Announcement2(title: announcement.title, content: announcement.content)
        }
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expectedKnowledgeGroupsExpectation = expectation(description: "Expected announcements to be extracted from sync response")
        context.application.fetchAnnouncements { (announcements) in
            if expected == announcements {
                expectedKnowledgeGroupsExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
}
