//
//  WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups: XCTestCase {

    func testTheGroupsFromTheStoreAreAdaptedInOrder() {
        let dataStore = FakeDataStore()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)

        KnowledgeGroupAssertion().assertGroups(observer.capturedGroups,
                                               characterisedByGroup: syncResponse.knowledgeGroups.changed,
                                               entries: syncResponse.knowledgeEntries.changed)
    }

}
