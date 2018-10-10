//
//  WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups: XCTestCase {
    
    func testTheGroupsFromTheStoreAreAdaptedInOrder() {
        let dataStore = CapturingEurofurenceDataStore()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let expected = context.expectedKnowledgeGroups(from: syncResponse)
        let observer = CapturingKnowledgeServiceObserver()
        context.application.add(observer)
        
        XCTAssertEqual(expected, observer.capturedGroups)
    }
    
}
