//
//  WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh: XCTestCase {

    func testEntriesAreConsolidatedByGroupIdentifierInGroupOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = context.expectedKnowledgeGroups(from: syncResponse)

        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingKnowledgeServiceObserver()
        context.application.add(observer)

        XCTAssertEqual(expected, observer.capturedGroups)
    }

    func testEarlyBoundObserversAreUpdatedWithNewKnowledgeGroups() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingKnowledgeServiceObserver()
        context.application.add(observer)
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let expected = context.expectedKnowledgeGroups(from: syncResponse)
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertEqual(expected, observer.capturedGroups)
    }

}
