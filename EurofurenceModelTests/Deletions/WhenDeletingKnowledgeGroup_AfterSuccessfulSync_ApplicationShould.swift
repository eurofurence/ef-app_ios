//
//  WhenDeletingKnowledgeGroup_AfterSuccessfulSync_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDeletingKnowledgeGroup_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testTellTheStoreToDeleteTheGroup() {
        let dataStore = FakeDataStore()
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().with(dataStore).build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let groupToDelete = String.random
        response.knowledgeGroups.deleted = [groupToDelete]
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)

        XCTAssertEqual([groupToDelete], dataStore.transaction.deletedKnowledgeGroups)
    }

}
