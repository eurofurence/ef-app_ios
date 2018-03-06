//
//  WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh: XCTestCase {
    
    func testEntriesAreConsolidatedByGroupIdentifier() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = KnowledgeGroup2.fromServerModels(groups: syncResponse.knowledgeGroups.changed, entries: syncResponse.knowledgeEntries.changed)
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expectedKnowledgeGroupsExpectation = expectation(description: "Expected knowledge groups to be extracted from sync response")
        context.application.fetchKnowledgeGroups { (groups) in
            if expected == groups {
                expectedKnowledgeGroupsExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
}
