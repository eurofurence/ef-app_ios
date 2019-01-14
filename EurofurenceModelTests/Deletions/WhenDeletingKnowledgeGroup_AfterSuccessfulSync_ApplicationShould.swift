//
//  WhenDeletingKnowledgeGroup_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenDeletingKnowledgeGroup_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheGroup() {
        let dataStore = CapturingEurofurenceDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let groupToDelete = String.random
        response.knowledgeGroups.deleted = [groupToDelete]
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)

        XCTAssertEqual([groupToDelete], dataStore.transaction.deletedKnowledgeGroups)
    }

}
